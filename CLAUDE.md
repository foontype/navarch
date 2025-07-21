# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
NAVARCH is a Bash-based single script CLI system for managing project dependencies and configurations. It uses `atlas.navarch` files to define dependencies and lifecycle functions (build, up, down, clean).

## Essential Commands

### Testing
```bash
# Run all tests
bats tests/test_navarch.bats

# Run a specific test
bats tests/test_navarch.bats --filter "test name"
```

### Development Installation
```bash
# Make script executable and create symlink
chmod +x src/navarch
ln -s $(pwd)/src/navarch ~/.local/bin/navarch
```

### Code Quality
```bash
# Lint bash scripts
shellcheck src/navarch

# Format bash scripts
shfmt -w src/navarch
```

## Architecture Overview

### Single Script Design
The entire CLI is implemented in `src/navarch` - a single Bash script that:
- Parses `atlas.navarch` configuration files
- Manages vendor dependencies with intelligent caching
- Executes lifecycle functions in proper order

### Key Concepts
1. **Directives**: Configuration commands in atlas.navarch
   - `env <file>`: Load environment variables
   - `vendor <github-url>`: Pull GitHub repository dependencies
   - `current <path>`: Include local directory dependencies

2. **Functions**: Lifecycle commands defined in atlas.navarch
   - `build()`, `up()`: Execute in definition order
   - `down()`, `clean()`: Execute in reverse order

3. **Caching**: Vendor dependencies cached in `.cache/` directory

### Testing Approach
- Uses BATS (Bash Automated Testing System)
- Tests located in `tests/test_navarch.bats`
- Each test creates isolated temporary environment
- Tests validate both exit codes and output

## Git Workflow

### Creating Pull Requests
**IMPORTANT: Never push directly to main branch. Always use feature branches.**

1. Check existing PRs:
   ```
   mcp__github__list_pull_requests
   ```

2. Create new branch (naming: `work/claude/<feature>`):
   ```bash
   git checkout -b work/claude/<feature-name>
   ```

3. Push branch:
   ```bash
   git push -u origin work/claude/<feature-name>
   ```

4. Create PR using GitHub MCP:
   ```
   mcp__github__create_pull_request
   ```

## Development Environment
- DevContainer with Ubuntu, Bash, Go, Node.js
- Pre-installed: BATS, ShellCheck, shfmt
- Claude Code extension integrated

## Important Implementation Notes
- POSIX compatible, requires Bash 4.0+
- No build process - direct script execution
- Version defined in script: `VERSION="1.0.0"`
- Error handling uses consistent exit codes
- GitHub URLs parsed with specific regex pattern

## Key Files
- `src/navarch`: Main CLI script
- `tests/test_navarch.bats`: Test suite
- `atlas.navarch`: Example configuration
- `docs/plan*.md`: Architecture documentation (Japanese)