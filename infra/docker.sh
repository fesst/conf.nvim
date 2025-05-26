#!/bin/bash

# Source shared library for utility functions
source infra/lib.sh
# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Set image name
IMAGE_NAME="ghcr.io/fesst/conf.nvim:latest"

# Check if we should build locally
if [ "$1" == "--local" ]; then
    print_status "Building Docker image locally..."
    docker build -t neovim-dev .
    IMAGE_NAME="neovim-dev"
else
    print_status "Pulling Docker image from GitHub Container Registry..."
    docker pull $IMAGE_NAME || {
        print_warning "Failed to pull image. Building locally..."
        docker build -t neovim-dev .
        IMAGE_NAME="neovim-dev"
    }
fi

# Create a volume for persistent data
print_status "Creating Docker volume for persistent data..."
docker volume create neovim-data

# Run the container
print_status "Starting Neovim container..."
docker run -it --rm \
    -v neovim-data:/home/developer/.local/share/nvim \
    -v "$(pwd):/workspace" \
    -w /workspace \
    --name neovim-dev \
    $IMAGE_NAME

# Check if container was started successfully
if [ $? -ne 0 ]; then
    print_error "Failed to start container"
    exit 1
fi

print_status "Container stopped"
