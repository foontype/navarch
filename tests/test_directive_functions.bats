#!/usr/bin/env bats

# ディレクティブ関数のテスト

setup() {
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PWD="$PWD"
    cd "$TEST_DIR"
    
    # グローバル配列の初期化
    ENV_LIST=()
    VENDOR_LIST=()
    CURRENT_LIST=()
}

teardown() {
    cd "$ORIGINAL_PWD"
    rm -rf "$TEST_DIR"
}

@test "env() should add environment file to ENV_LIST" {
    # env()関数の動作テスト
    skip "関数未実装"
}

@test "vendor() should add GitHub repository to VENDOR_LIST" {
    # vendor()関数の動作テスト
    skip "関数未実装"
}

@test "current() should add local directory to CURRENT_LIST" {
    # current()関数の動作テスト
    skip "関数未実装"
}