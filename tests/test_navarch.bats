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