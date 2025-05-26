# Docker Development Environment

This guide explains how to use the Docker-based Neovim development environment.

## Quick Start

1. Pull and run the container:

   ```bash
   ./infra/docker.sh
   ```

2. Build and run locally:

   ```bash
   ./infra/docker.sh --local
   ```

## Features

The Docker environment includes:

### System Tools

- Git
- Build tools (build-essential, cmake, pkg-config)
- SSL development libraries
- LLVM and Clang
- Make

### Language Support

- Python 3 with pip and venv
- Node.js and npm
- Rust (via rustup)
- Lua (via luarocks)

### Development Tools

- Ripgrep for fast searching
- fd-find for file finding
- fzf for fuzzy finding
- ShellCheck for shell script linting
- shfmt for shell script formatting
- PostgreSQL and client tools
- pgformatter for SQL formatting

### Language Servers and Tools

- TypeScript/JavaScript
  - typescript
  - typescript-language-server
  - prettier
  - eslint
  - eslint_d
- Python
  - pynvim
  - black
  - flake8
  - isort
- Lua
  - luacheck
  - stylua
- SQL
  - sql-language-server
- Angular
  - @angular/cli

## Usage

### Basic Usage

The `docker.sh` script provides two modes:

1. **Remote Mode** (default):
   - Pulls the image from GitHub Container Registry (ghcr.io/fesst/conf.nvim:latest)
   - Falls back to local build if pull fails

   ```bash
   ./infra/docker.sh
   ```

2. **Local Mode**:
   - Builds the image locally
   - Useful for development or when offline

   ```bash
   ./infra/docker.sh --local
   ```

### Volume Management

The container uses two types of volumes:

1. **Persistent Data** (`neovim-data`):
   - Stores Neovim plugins and data
   - Persists between container runs
   - Located at `/home/developer/.local/share/nvim`

2. **Workspace** (current directory):
   - Mounts your current directory as `/workspace`
   - Changes are reflected in both container and host
   - Perfect for development

### Environment

The container provides:

- Non-root user (`developer`)
- Full development toolchain
- Persistent Neovim configuration
- Automatic plugin installation via Lazy

## Development Workflow

### Starting a Session

1. Navigate to your project directory
2. Run the Docker script:

   ```bash
   ./infra/docker.sh
   ```

3. Neovim will start automatically with your configuration

### Using the Environment

1. **Plugin Management**:
   - Plugins are installed automatically via Lazy
   - Use `:Lazy` to manage plugins
   - Changes persist between sessions

2. **Language Support**:
   - LSP servers are installed via Mason
   - Use `:Mason` to manage language servers
   - Debug adapters are available for supported languages

3. **File Management**:
   - Use NvimTree for file navigation
   - Telescope for fuzzy finding
   - Harpoon for quick file access

### Exiting

1. Save your work in Neovim
2. Exit Neovim with `:qa`
3. The container will stop automatically

## Customization

### Building Custom Image

1. Clone the repository:

   ```bash
   git clone https://github.com/fesst/conf.nvim.git
   cd conf.nvim
   ```

2. Modify the Dockerfile to add custom tools:

   ```dockerfile
   # Add your custom installations here
   RUN apt-get update && apt-get install -y \
       your-custom-tool
   ```

3. Build and run:

   ```bash
   ./infra/docker.sh --local
   ```

## Troubleshooting

### Common Issues

1. **Docker Not Installed**:
   - The script will check for Docker installation
   - Install Docker if not present

2. **Image Pull Failed**:
   - Check your internet connection
   - Verify GitHub Container Registry access
   - Use `--local` flag to build locally

3. **Permission Issues**:
   - The container runs as non-root user `developer`
   - All necessary directories are properly owned
   - Check volume permissions if issues occur

4. **Plugin Issues**:
   - Run `:Lazy sync` to force plugin sync
   - Check Mason logs with `:MasonLog`
   - Verify network connectivity

### Getting Help

- Open an issue on GitHub
- Check the [Neovim documentation](https://neovim.io/doc/)
- Review the [Docker documentation](https://docs.docker.com/)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
