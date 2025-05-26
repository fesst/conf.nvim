# Use Ubuntu as base image
FROM ubuntu:22.04

# Add metadata labels
LABEL org.opencontainers.image.title="Neovim Development Environment"
LABEL org.opencontainers.image.description="A complete Neovim development environment with all necessary tools and language servers"
LABEL org.opencontainers.image.source="https://github.com/fesst/conf.nvim"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="fesst"

# Add build arguments for architecture
ARG TARGETARCH
ARG TARGETVARIANT

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies in groups
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install basic development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Python and related tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install search and formatting tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep \
    fd-find \
    fzf \
    shellcheck \
    shfmt \
    && rm -rf /var/lib/apt/lists/*

# Install PostgreSQL and related tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql \
    postgresql-client \
    pgformatter \
    && rm -rf /var/lib/apt/lists/*

# Install Lua and compiler tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    luarocks \
    llvm \
    clang \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x (Latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Neovim based on architecture
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
        tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
        ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
        rm nvim-linux-x86_64.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz && \
        tar -C /opt -xzf nvim-linux-arm64.tar.gz && \
        ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim && \
        rm nvim-linux-arm64.tar.gz; \
    fi

# Create neovim config directory
RUN mkdir -p /root/.config/nvim

# Copy configuration files
COPY . /root/.config/nvim/

# Install Python packages
RUN python3 -m pip install --no-cache-dir \
    pynvim \
    black \
    flake8 \
    isort

# Install npm packages
RUN npm install -g --no-fund --no-audit --no-package-lock --no-save \
    typescript@latest \
    typescript-language-server@latest \
    prettier@latest \
    eslint@latest \
    @angular/cli@latest \
    sql-language-server@latest \
    eslint_d@latest

# Install LuaRocks packages
RUN luarocks install luacheck

# Install Cargo packages
RUN cargo install stylua

# Set working directory
WORKDIR /workspace

# Create a non-root user
RUN useradd -m -s /bin/bash developer
RUN chown -R developer:developer /workspace /root/.config/nvim

# Switch to non-root user
USER developer

# Set environment variables
ENV PATH="/home/developer/.cargo/bin:${PATH}"
ENV PATH="/home/developer/.local/bin:${PATH}"

# Create necessary directories for the user
RUN mkdir -p /home/developer/.config/nvim \
    && mkdir -p /home/developer/.local/share/nvim \
    && mkdir -p /home/developer/.cache/nvim

# Copy configuration files to user's home
COPY --chown=developer:developer . /home/developer/.config/nvim/

# Install Neovim plugins (skip in CI)
RUN if [ "$CI" != "true" ]; then \
        nvim --headless -c "Lazy sync" -c "qa"; \
    fi

# Set the default command
CMD ["nvim"]
