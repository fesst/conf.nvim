#!/bin/bash

# Source shared library for utility functions
source "$(dirname "$0")/lib.sh"

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Get the root directory (one level up from infra)
ROOT_DIR="$(dirname "$(dirname "$0")")"

# Default to ARM64
ARCH="arm64"
DOCKERFILE="${ROOT_DIR}/Dockerfile.arm64"
LOCAL=false
BUILD=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    --local)
        LOCAL=true
        shift
        ;;
    --amd64)
        ARCH="amd64"
        DOCKERFILE="${ROOT_DIR}/Dockerfile.amd64"
        shift
        ;;
    build)
        BUILD=true
        shift
        ;;
    arm64)
        ARCH="arm64"
        DOCKERFILE="${ROOT_DIR}/Dockerfile.arm64"
        shift
        ;;
    *)
        print_error "Unknown option: $1"
        print_status "Usage: $0 [--local] [--amd64] [build] [arm64|amd64]"
        exit 1
        ;;
    esac
done

# Set image name
IMAGE_NAME="ghcr.io/fesst/conf.nvim:${ARCH}"

# If build command is specified, only build the image
if [ "$BUILD" = true ]; then
    print_status "Building Docker image for ${ARCH}..."
    docker build -t neovim-dev-${ARCH} -f "${DOCKERFILE}" "${ROOT_DIR}"
    exit $?
fi

# Check if we should build locally
if [ "$LOCAL" = true ]; then
    print_status "Building Docker image locally for ${ARCH}..."
    docker build -t neovim-dev-${ARCH} -f "${DOCKERFILE}" "${ROOT_DIR}"
    IMAGE_NAME="neovim-dev-${ARCH}"
else
    print_status "Pulling Docker image from GitHub Container Registry..."
    docker pull $IMAGE_NAME || {
        print_warning "Failed to pull image. Building locally..."
        docker build -t neovim-dev-${ARCH} -f "${DOCKERFILE}" "${ROOT_DIR}"
        IMAGE_NAME="neovim-dev-${ARCH}"
    }
fi

# Create a volume for persistent data
print_status "Creating Docker volume for persistent data..."
docker volume create neovim-data-${ARCH}

# Run the container
print_status "Starting Neovim container for ${ARCH}..."
docker run -it --rm \
    -v neovim-data-${ARCH}:/home/developer/.local/share/nvim \
    -v "${ROOT_DIR}:/workspace" \
    -w /workspace \
    --name neovim-dev-${ARCH} \
    $IMAGE_NAME

# Check if container was started successfully
if [ $? -ne 0 ]; then
    print_error "Failed to start container"
    exit 1
fi

print_status "Container stopped"
