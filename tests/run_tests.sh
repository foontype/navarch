#!/bin/bash

# NAVARCH CLIテスト実行スクリプト

set -e

echo "=== NAVARCH CLI テストスイート ==="
echo

# テストディレクトリの確認
if [ ! -d "tests" ]; then
    echo "Error: testsディレクトリが見つかりません"
    exit 1
fi

# batsの確認
if ! command -v bats >/dev/null 2>&1; then
    echo "Error: batsが見つかりません"
    echo "batsをインストールしてください: https://github.com/bats-core/bats-core"
    exit 1
fi

echo "batsバージョン: $(bats --version)"
echo

# 全テストファイルを実行
echo "テスト実行中..."
echo

for test_file in tests/test_*.bats; do
    if [ -f "$test_file" ]; then
        echo "実行中: $test_file"
        bats "$test_file"
        echo
    fi
done

echo "=== テスト完了 ==="