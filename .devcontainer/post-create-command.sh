#!/bin/bash
set -e

echo "Setting up development environment..."

# Install shfmt (Go-based shell formatter)
echo "Installing shfmt..."
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Update package list and install shellcheck
echo "Installing shellcheck..."
sudo apt-get update
sudo apt-get install -y shellcheck

echo "Development container setup complete!"