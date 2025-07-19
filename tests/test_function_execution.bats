#!/usr/bin/env bats

# 関数実行エンジンのテスト

setup() {
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PWD="$PWD"
    cd "$TEST_DIR"
}

teardown() {
    cd "$ORIGINAL_PWD"
    rm -rf "$TEST_DIR"
}

@test "load_functions should extract subcommand functions from atlas.navarch" {
    # 関数抽出のテスト
    skip "関数未実装"
}

@test "execute_subcommand should run specified subcommand in project directory" {
    # サブコマンド実行のテスト
    skip "関数未実装"
}

@test "execute_in_order should process project list in specified order" {
    # 順序実行制御のテスト
    skip "関数未実装"
}