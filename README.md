# NAVARCH CLI System

[![Tests](https://github.com/foontype/navarch/actions/workflows/ci.yml/badge.svg)](https://github.com/foontype/navarch/actions/workflows/ci.yml)

A Bash-based single script CLI system for managing atlas.navarch configurations.

## Features

- **Pull Dependencies**: Download and cache GitHub repositories specified in `vendor` directives
- **Execute Commands**: Run build, up, down, and clean functions defined in atlas.navarch files
- **Environment Management**: Load environment variables from specified files
- **Local Dependencies**: Support for local project dependencies with `current` directives
- **Plugin System**: Load external Bash functions from separate files with `plugin` directives
- **Task System**: Execute custom tasks from external files with `task` directives
- **Caching**: Intelligent caching of vendor repositories in `.cache` directory
- **POSIX Compatible**: Works with standard Bash (version 4.0+)

## Installation

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/foontype/navarch/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/foontype/navarch.git
cd navarch
./install.sh
```

### Development Install

```bash
# Clone the repository
git clone https://github.com/foontype/navarch.git
cd navarch

# Make the script executable
chmod +x src/navarch

# Use directly or symlink to PATH
ln -s $(pwd)/src/navarch ~/.local/bin/navarch
```

## Usage

### Basic Commands

```bash
# Show help
navarch --help

# Show version
navarch --version

# Pull vendor dependencies
navarch pull

# Execute build functions
navarch build

# Execute up functions
navarch up

# Execute down functions (reverse order)
navarch down

# Execute clean functions (reverse order)
navarch clean

# Run custom task
navarch run <task_name>
```

### atlas.navarch File Format

Create an `atlas.navarch` file in your project root:

```bash
# Environment files to load
env .env
env .env.local

# GitHub dependencies (vendor)
vendor https://github.com/user/repo.git
vendor https://github.com/user/repo.git@v1.0.0

# Local dependencies (current)
current ./local-project
current ../shared-project

# Plugin files with shared functions
plugin lib/helpers.sh
plugin scripts/database.sh

# Task files with executable tasks
task tasks/deploy.sh
task tasks/maintenance.sh

# Build function
build() {
    echo "Building main project"
    # Use function from plugin
    setup_environment
    npm install
    npm run build
}

# Up function
up() {
    echo "Starting services"
    docker-compose up -d
}

# Down function
down() {
    echo "Stopping services"
    docker-compose down
}

# Clean function
clean() {
    echo "Cleaning build artifacts"
    rm -rf node_modules dist
}
```

## Directory Structure

```
project/
├── atlas.navarch          # Main configuration file
├── lib/                   # Plugin files directory
│   ├── helpers.sh         # Shared utility functions
│   └── database.sh        # Database-related functions
├── tasks/                 # Task files directory
│   ├── deploy.sh          # Deployment tasks
│   └── maintenance.sh     # Maintenance tasks
├── .cache/                # Vendor dependencies cache
│   ├── user1/repo1/       # Cached repository
│   └── user2/repo2/       # Another cached repository
├── .env                   # Environment variables
└── src/                   # Your project source
```

## Directives

### env
Load environment variables from specified files.

```bash
env .env
env .env.production
```

### vendor
Pull GitHub repositories as dependencies.

```bash
vendor https://github.com/user/repo.git
vendor https://github.com/user/repo.git@branch-name
vendor https://github.com/user/repo.git@v1.0.0
```

### current
Include local directories as dependencies.

```bash
current ./local-project
current ../shared-library
```

### plugin
Load external Bash functions from separate files. Plugin files are loaded before subcommand execution, making their functions available in atlas.navarch lifecycle functions.

```bash
plugin lib/helpers.sh
plugin utils/database.sh
plugin ../shared/common.sh
```

Plugin files can contain any valid Bash functions:

```bash
# lib/helpers.sh
setup_environment() {
    echo "Setting up build environment..."
    export NODE_ENV=production
}

compile_assets() {
    echo "Compiling frontend assets..."
    npm run build:assets
}
```

These functions can then be used in your atlas.navarch lifecycle functions:

```bash
build() {
    setup_environment
    compile_assets  
    echo "Build complete"
}
```

### task
Load external task files containing functions that can be executed with `navarch run`. Unlike plugins, task functions are meant to be run directly as standalone commands.

```bash
task tasks/deploy.sh
task tasks/maintenance.sh
task ../shared/operations.sh
```

Task files contain functions that can be executed individually:

```bash
# tasks/deploy.sh
deploy_staging() {
    echo "Deploying to staging environment..."
    docker build -t myapp:staging .
    kubectl apply -f k8s/staging/
    echo "Staging deployment complete"
}

deploy_production() {
    echo "Deploying to production..."
    docker build -t myapp:prod .
    kubectl apply -f k8s/production/
    echo "Production deployment complete"
}

rollback_production() {
    echo "Rolling back production deployment..."
    kubectl rollout undo deployment/myapp
}
```

Execute these tasks with the `run` command:

```bash
navarch run deploy_staging
navarch run deploy_production  
navarch run rollback_production
```

## Testing

Run the test suite with:

```bash
bats tests/test_navarch.bats
```

## Development

### Project Structure

```
navarch/
├── src/navarch             # Main script
├── tests/                  # Test suite
├── docs/                   # Documentation
├── install.sh              # Installation script
└── README.md              # This file
```

### Building from Source

The project is a single Bash script, so no build process is needed. However, you can run tests to verify functionality:

```bash
# Run tests
bats tests/test_navarch.bats

# Test installation
./install.sh
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Requirements

- Bash 4.0+
- Git
- Standard POSIX utilities (mkdir, chmod, etc.)

## Troubleshooting

### Common Issues

**navarch command not found**
- Add the installation directory to your PATH
- For ~/.local/bin installations: `export PATH="$HOME/.local/bin:$PATH"`

**Permission denied when pulling repositories**
- Ensure you have access to the specified GitHub repositories
- For private repositories, set up SSH keys or authentication

**Functions not executing**
- Verify your atlas.navarch file has the correct function definitions
- Check that functions are properly defined with `function_name() { ... }`

### Debug Mode

Enable debug output with the `--debug` flag:

```bash
navarch --debug pull
navarch --debug build
```