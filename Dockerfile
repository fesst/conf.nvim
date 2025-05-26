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

# Configure apt with multiple mirrors and better error handling
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::http::Timeout "180";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::https::Timeout "180";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::ftp::Timeout "180";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'APT::Get::Show-Upgraded "true";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Dpkg::Options::="--force-confdef";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Dpkg::Options::="--force-confold";' >> /etc/apt/apt.conf.d/80-retries

# Configure architecture-specific mirrors
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        echo "deb http://mirrors.edge.kernel.org/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
        echo "deb http://mirrors.edge.kernel.org/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://mirrors.edge.kernel.org/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://mirrors.edge.kernel.org/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://mirrors.ocf.berkeley.edu/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://mirrors.ocf.berkeley.edu/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://mirrors.ocf.berkeley.edu/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://mirrors.ocf.berkeley.edu/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    else \
        echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
        echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo "deb http://ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    fi

# Install packages in groups with error handling
RUN apt-get clean && \
    apt-get update --fix-missing || (echo "Failed to update package lists" && exit 1)

# Install essential system packages first
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/* || (echo "Failed to install essential packages" && exit 1)

# Install development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    make \
    && rm -rf /var/lib/apt/lists/* || (echo "Failed to install development tools" && exit 1)

# Install Python and related tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* || (echo "Failed to install Python tools" && exit 1)

# Install search and formatting tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ripgrep \
    fd-find \
    fzf \
    shellcheck \
    shfmt \
    && rm -rf /var/lib/apt/lists/* || (echo "Failed to install search and formatting tools" && exit 1)

# Install PostgreSQL and related tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql \
    postgresql-client \
    pgformatter \
    && rm -rf /var/lib/apt/lists/* || (echo "Failed to install PostgreSQL tools" && exit 1)

# Install Lua and compiler tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    luarocks \
    llvm \
    clang \
    gcc \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* || (echo "Failed to install Lua and compiler tools" && exit 1)

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
