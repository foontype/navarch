#!/bin/bash
set -e

echo "Setting up development environment..."

# Setup ${HOME}/.claude directory
echo "Setup claude directory permissions ..."
sudo chown -R "$(id -u):$(id -g)" "${HOME}/.claude"
sudo chmod -R 755 "${HOME}/.claude"

# Install shfmt (Go-based shell formatter)
echo "Installing shfmt..."
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Install github-mcp-server (Go-based github mcp server)
echo "Installing github-mcp-server..."
go install github.com/github/github-mcp-server/cmd/github-mcp-server@latest

# Update package list and install shellcheck
echo "Installing shellcheck..."
sudo apt-get update
sudo apt-get install -y shellcheck

echo "Development container setup complete!"