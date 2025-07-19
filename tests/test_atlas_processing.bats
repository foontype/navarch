#!/usr/bin/env bats

# atlas.navarch処理エンジンのテスト

setup() {
    export TEST_DIR=$(mktemp -d)
    export ORIGINAL_PWD="$PWD"
    cd "$TEST_DIR"
}

teardown() {
    cd "$ORIGINAL_PWD"
    rm -rf "$TEST_DIR"
}

@test "find_atlas_navarch should locate atlas.navarch file" {
    # atlas.navarchファイルの検索テスト
    echo "# test atlas.navarch" > atlas.navarch
    skip "関数未実装"
}

@test "define_directive_functions should create env(), vendor(), current() functions" {
    # ディレクティブ関数の動的定義テスト
    skip "関数未実装"
}

@test "source_atlas_navarch should execute atlas.navarch file" {
    # atlas.navarchファイルのsource実行テスト
    skip "関数未実装"
}

@test "build_dependency_tree should create ordered project list" {
    # 依存関係ツリーの構築テスト
    skip "関数未実装"
}