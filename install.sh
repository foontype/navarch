#!/bin/bash

# NAVARCH CLI Installation Script

set -euo pipefail

# Configuration
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="navarch"
REPO_URL="https://raw.githubusercontent.com/foontype/navarch/main/src/navarch"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Check if running as root for system-wide installation
check_permissions() {
    if [[ $EUID -eq 0 ]]; then
        log_info "Installing system-wide to $INSTALL_DIR"
    else
        if [[ ! -w "$INSTALL_DIR" ]]; then
            log_warn "No write permission to $INSTALL_DIR"
            log_info "Installing to ~/.local/bin instead"
            INSTALL_DIR="$HOME/.local/bin"
            mkdir -p "$INSTALL_DIR"
        fi
    fi
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v git >/dev/null 2>&1; then
        missing_deps+=("git")
    fi
    
    if ! command -v bash >/dev/null 2>&1; then
        missing_deps+=("bash")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_error "Please install the missing dependencies and try again."
        exit 1
    fi
    
    log_info "All dependencies are satisfied"
}

# Download and install navarch
install_navarch() {
    local target_path="$INSTALL_DIR/$SCRIPT_NAME"
    
    log_info "Installing navarch to $target_path"
    
    # If we're in a development environment, copy from src/
    if [[ -f "src/navarch" ]]; then
        log_info "Using local development version"
        cp "src/navarch" "$target_path"
    else
        # Download from repository
        log_info "Downloading from $REPO_URL"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$REPO_URL" -o "$target_path"
        elif command -v wget >/dev/null 2>&1; then
            wget -q "$REPO_URL" -O "$target_path"
        else
            log_error "Neither curl nor wget is available. Cannot download navarch."
            exit 1
        fi
    fi
    
    # Make executable
    chmod +x "$target_path"
    
    log_info "navarch installed successfully!"
}

# Verify installation
verify_installation() {
    if command -v navarch >/dev/null 2>&1; then
        local version
        version=$(navarch --version)
        log_info "Installation verified: $version"
    else
        log_warn "navarch command not found in PATH."
        log_info "You may need to add $INSTALL_DIR to your PATH:"
        log_info "  export PATH=\"$INSTALL_DIR:\$PATH\""
        log_info "Add this line to your ~/.bashrc or ~/.zshrc file."
    fi
}

# Show usage information
show_usage() {
    log_info "navarch has been installed!"
    log_info ""
    log_info "Quick start:"
    log_info "  1. Create an atlas.navarch file in your project"
    log_info "  2. Run 'navarch pull' to download dependencies"
    log_info "  3. Run 'navarch build' to build your project"
    log_info ""
    log_info "For more information, run: navarch --help"
}

# Main installation process
main() {
    log_info "Starting navarch installation..."
    
    check_permissions
    check_dependencies
    install_navarch
    verify_installation
    show_usage
    
    log_info "Installation complete!"
}

# Run main function
main "$@"