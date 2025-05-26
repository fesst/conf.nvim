# Use Ubuntu as base image
FROM ubuntu:22.04

# Add metadata labels
LABEL org.opencontainers.image.title="Neovim Development Environment"
LABEL org.opencontainers.image.description="A complete Neovim development environment with all necessary tools and language servers"
LABEL org.opencontainers.image.source="https://github.com/fesst/conf.nvim"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="fesst"

# Add build arguments for architecture
ARG TARGETARCH=amd64
ARG TARGETVARIANT=

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Add retry logic and multiple mirrors
RUN echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::http::Timeout "120";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::https::Timeout "120";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::ftp::Timeout "120";' >> /etc/apt/apt.conf.d/80-retries && \
    sed -i 's/archive.ubuntu.com/mirrors.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ubuntu.com/g' /etc/apt/sources.list

# Install all required packages in a single RUN command
RUN apt-get clean && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    # System dependencies
    ca-certificates \
    gnupg \
    # Basic development tools
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    make \
    # Python and related tools
    python3 \
    python3-pip \
    python3-venv \
    # Search and formatting tools
    ripgrep \
    fd-find \
    fzf \
    shellcheck \
    shfmt \
    # PostgreSQL and related tools
    postgresql \
    postgresql-client \
    pgformatter \
    # Lua and compiler tools
    luarocks \
    llvm \
    clang \
    gcc \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x (Latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Neovim based on architecture
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

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

# Install Cargo packages with fallback
RUN if ! cargo install stylua; then \
        echo "Failed to install stylua via cargo, trying alternative method..." && \
        curl -L https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux.zip -o stylua.zip && \
        unzip stylua.zip && \
        chmod +x stylua && \
        mv stylua /usr/local/bin/ && \
        rm stylua.zip; \
    fi

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
