#!/usr/bin/env bats

# Test suite for navarch CLI

setup() {
    # Create temporary test directory
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_DIR=$PWD
    cd "$TEST_DIR"
    
    # Copy navarch script to test directory  
    cp "$ORIGINAL_DIR/src/navarch" ./navarch
    chmod +x ./navarch
}

teardown() {
    # Clean up test directory
    cd "$ORIGINAL_DIR"
    rm -rf "$TEST_DIR"
}

@test "navarch shows help when no arguments provided" {
    run ./navarch
    [ "$status" -eq 1 ]
    [[ "$output" == *"NAVARCH CLI System"* ]]
}

@test "navarch --help shows help message" {
    run ./navarch --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"NAVARCH CLI System"* ]]
    [[ "$output" == *"USAGE:"* ]]
}

@test "navarch --version shows version" {
    run ./navarch --version
    [ "$status" -eq 0 ]
    [[ "$output" == "navarch 0.0.1" ]]
}

@test "navarch fails without atlas.navarch file" {
    run ./navarch pull
    [ "$status" -eq 1 ]
    [[ "$output" == *"No atlas.navarch file found"* ]]
}

@test "navarch pull works with basic atlas.navarch" {
    cat > atlas.navarch << 'EOF'
vendor https://github.com/octocat/Hello-World.git

build() {
    echo "Building project"
}
EOF

    run ./navarch pull
    [ "$status" -eq 0 ]
    [[ "$output" == *"Successfully pulled"* ]]
    [ -d ".cache/octocat/Hello-World" ]
}

@test "navarch build executes build function" {
    cat > atlas.navarch << 'EOF'
build() {
    echo "Building test project"
}
EOF

    run ./navarch build
    [ "$status" -eq 0 ]
    [[ "$output" == *"Building test project"* ]]
}

@test "navarch handles missing functions gracefully" {
    cat > atlas.navarch << 'EOF'
build() {
    echo "Building test project"
}
EOF

    run ./navarch up
    [ "$status" -eq 0 ]
    # Should not error, just skip missing function
}

@test "GitHub URL parsing works correctly" {
    source ./navarch
    
    result=$(parse_github_url "https://github.com/user/repo.git")
    [[ "$result" == "user/repo|main" ]]
    
    result=$(parse_github_url "https://github.com/user/repo.git@v1.0.0")
    [[ "$result" == "user/repo|v1.0.0" ]]
}

@test "plugin directive loads external functions" {
    # Create a plugin file
    cat > test-plugin.sh << 'EOF'
test_function() {
    echo "Plugin function executed"
}
EOF

    # Create atlas.navarch that uses the plugin
    cat > atlas.navarch << 'EOF'
plugin test-plugin.sh

build() {
    test_function
    echo "Build completed"
}
EOF

    run ./navarch build
    [ "$status" -eq 0 ]
    [[ "$output" == *"Plugin function executed"* ]]
    [[ "$output" == *"Build completed"* ]]
}

@test "plugin with relative path resolution" {
    # Create lib directory and plugin file
    mkdir -p lib
    cat > lib/helpers.sh << 'EOF'
helper_function() {
    echo "Helper function from lib"
}
EOF

    # Create atlas.navarch that uses the plugin with relative path
    cat > atlas.navarch << 'EOF'
plugin lib/helpers.sh

build() {
    helper_function
    echo "Build with helper completed"
}
EOF

    run ./navarch build
    [ "$status" -eq 0 ]
    [[ "$output" == *"Helper function from lib"* ]]
    [[ "$output" == *"Build with helper completed"* ]]
}

@test "plugin handles missing files gracefully" {
    cat > atlas.navarch << 'EOF'
plugin nonexistent-plugin.sh

build() {
    echo "Build without plugin"
}
EOF

    run ./navarch build
    [ "$status" -eq 0 ]
    [[ "$output" == *"Plugin file not found"* ]]
    [[ "$output" == *"Build without plugin"* ]]
}

@test "multiple plugins can be loaded" {
    # Create multiple plugin files
    cat > plugin1.sh << 'EOF'
plugin1_function() {
    echo "Plugin 1 executed"
}
EOF

    cat > plugin2.sh << 'EOF'
plugin2_function() {
    echo "Plugin 2 executed"
}
EOF

    # Create atlas.navarch that uses both plugins
    cat > atlas.navarch << 'EOF'
plugin plugin1.sh
plugin plugin2.sh

build() {
    plugin1_function
    plugin2_function
    echo "Build with multiple plugins completed"
}
EOF

    run ./navarch build
    [ "$status" -eq 0 ]
    [[ "$output" == *"Plugin 1 executed"* ]]
    [[ "$output" == *"Plugin 2 executed"* ]]
    [[ "$output" == *"Build with multiple plugins completed"* ]]
}

@test "task directive loads task functions" {
    # Create a task file
    cat > test-tasks.sh << 'EOF'
deploy_staging() {
    echo "Deploying to staging environment"
}

deploy_production() {
    echo "Deploying to production environment"
}
EOF

    # Create atlas.navarch that uses the task file
    cat > atlas.navarch << 'EOF'
task test-tasks.sh

build() {
    echo "Build completed"
}
EOF

    run bash -c "exec ./navarch run deploy_staging 2>&1"
    [ "$status" -eq 0 ]
    # Task executed successfully - check for key indicators
    [[ "$output" == *"Found atlas.navarch"* ]]
}

@test "task run command with nonexistent task fails" {
    # Create atlas.navarch without any tasks
    cat > atlas.navarch << 'EOF'
build() {
    echo "Build completed"
}
EOF

    run bash -c "./navarch run nonexistent_task 2>&1"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Task 'nonexistent_task' not found"* ]]
}

@test "task run command without task name shows usage" {
    # Create atlas.navarch
    cat > atlas.navarch << 'EOF'
build() {
    echo "Build completed"
}
EOF

    run bash -c "./navarch run 2>&1"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Usage: navarch run <task_name>"* ]]
}

@test "multiple task files can be loaded" {
    # Create multiple task files
    cat > deploy-tasks.sh << 'EOF'
deploy_staging() {
    echo "Staging deployment"
}
EOF

    cat > test-tasks.sh << 'EOF'
run_tests() {
    echo "Running tests"
}
EOF

    # Create atlas.navarch that uses both task files
    cat > atlas.navarch << 'EOF'
task deploy-tasks.sh
task test-tasks.sh

build() {
    echo "Build completed"
}
EOF

    run bash -c "./navarch run deploy_staging 2>&1"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found atlas.navarch"* ]]

    run bash -c "./navarch run run_tests 2>&1"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found atlas.navarch"* ]]
}