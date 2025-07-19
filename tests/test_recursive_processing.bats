#!/usr/bin/env bats

# 再帰処理のテスト

setup() {
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PWD="$PWD"
    cd "$TEST_DIR"
}

teardown() {
    cd "$ORIGINAL_PWD"
    rm -rf "$TEST_DIR"
}

@test "detect_recursive_atlas should find atlas.navarch in dependency directories" {
    # 再帰的atlas.navarch検出のテスト
    mkdir -p subdir
    echo "# nested atlas.navarch" > subdir/atlas.navarch
    skip "関数未実装"
}

@test "detect_circular_dependency should identify circular dependencies" {
    # 循環依存検出のテスト
    skip "関数未実装"
}

@test "process_recursively should handle recursive atlas.navarch processing" {
    # 再帰処理のテスト
    skip "関数未実装"
}