#!/usr/bin/env bats

# サブコマンド実装関数のテスト

setup() {
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PWD="$PWD"
    cd "$TEST_DIR"
}

teardown() {
    cd "$ORIGINAL_PWD"
    rm -rf "$TEST_DIR"
}

@test "cmd_pull should download all vendor repositories" {
    # pullサブコマンドのテスト
    skip "関数未実装"
}

@test "cmd_build should execute build functions in order" {
    # buildサブコマンドのテスト
    skip "関数未実装"
}

@test "cmd_up should execute up functions in order" {
    # upサブコマンドのテスト
    skip "関数未実装"
}

@test "cmd_down should execute down functions in reverse order" {
    # downサブコマンドのテスト
    skip "関数未実装"
}

@test "cmd_clean should execute down then clean functions" {
    # cleanサブコマンドのテスト
    skip "関数未実装"
}