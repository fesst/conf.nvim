# Use Ubuntu as base image
FROM ubuntu:22.04

# Add metadata labels
LABEL org.opencontainers.image.title="Neovim Development Environment"
LABEL org.opencontainers.image.description="A complete Neovim development environment with all necessary tools and language servers"
LABEL org.opencontainers.image.source="https://github.com/fesst/conf.nvim"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="fesst"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    ripgrep \
    fd-find \
    fzf \
    shellcheck \
    shfmt \
    postgresql \
    postgresql-client \
    pgformatter \
    luarocks \
    llvm \
    clang \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz \
    && rm -rf /opt/nvim \
    && mkdir -p /opt/nvim \
    && tar -C /opt -xzf nvim-linux-arm64.tar.gz \
    && ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-arm64.tar.gz

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

# Install Neovim plugins
RUN nvim --headless -c "Lazy sync" -c "qa"

# Set the default command
CMD ["nvim"]
