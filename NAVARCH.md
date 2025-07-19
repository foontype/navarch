# NAVARCH Rev2 設計

## 概要
atlas.navarchベースの新しいNAVARCH CLIシステム。カレントディレクトリのatlas.navarchを読み込み、ディレクティブ関数による柔軟な依存関係管理を提供。

## 設計方針
- **atlas.navarch**: プロジェクトルートに配置するBashファイル
- **ディレクティブ関数**: env、vendor、currentの3つの関数を提供
- **依存関係管理**: vendorでGitHubリポジトリ、currentでローカルパスを管理
- **キャッシュシステム**: .cache以下にvendor依存関係をダウンロード

## アーキテクチャ

### atlas.navarch
- **形式**: Bashスクリプトファイル
- **場所**: プロジェクトルートの`atlas.navarch`
- **内容**: ディレクティブ関数の呼び出し

### ディレクティブ関数
- **env**: 環境変数ファイルを指定（内部でenvリストに追加）
- **vendor**: GitHubリポジトリからの依存関係（内部でvendorリストに追加）
- **current**: ローカルパスの依存関係（内部でcurrentリストに追加）
- **実装**: 各関数は内部的にプロジェクトリストを構築するのみ

### 処理順序
- **build/up**: atlas.navarchの記述順で処理
- **down**: atlas.navarchの記述順の逆順で処理
- **clean**: downを実行してからクリーンアップ

## 実装詳細

### atlas.navarchの読み込み
1. navarch CLIがカレントディレクトリのatlas.navarchを検索
2. ディレクティブ関数（env、vendor、current）を定義
3. atlas.navarchを実行してディレクティブを収集
4. 各ディレクティブ関数の呼び出し順序でプロジェクトリストを構築
5. vendor/currentに含まれるディレクトリにatlas.navarchがある場合は再帰処理

### 関数実行仕様
各ディレクトリの`atlas.navarch`では以下の処理を行う:
1. サブコマンド関数（build、up、down、clean等）を定義
2. navarch CLIが`atlas.navarch`ファイルをsource実行
3. `declare -f`で定義された関数を保存
4. 実行順序に従って対象のサブコマンド関数を呼び出し
5. 関数内でDocker、Kubernetes等の実際の処理を実行

### サブコマンド

#### pull
- vendorで指定されたGitHubリポジトリを`.cache`以下にダウンロード
- 既存のキャッシュがある場合は更新

#### build
- atlas.navarchの記述順でプロジェクトをビルド

#### up
- atlas.navarchの記述順でプロジェクトを起動

#### down
- atlas.navarchの記述順の逆順でプロジェクトを停止

#### clean
- downを実行
- atlas.navarchの記述順の逆順でプロジェクトをクリーンアップ

### ディレクトリ構造
```
project/
├── atlas.navarch         # 依存関係定義
├── .cache/               # vendor依存関係キャッシュ
│   └── github.com/
│       └── repo/
│           └── navarch-project/
│               └── atlas.navarch  # 再帰処理対象
└── navarch-project/    # current依存関係
    └── atlas.navarch     # 再帰処理対象
```

## 使用例

### atlas.navarch例
```bash
#!/bin/bash

# 環境変数ファイル
env .env

# GitHub依存関係
vendor https://github.com/repo/navarch-project

# ローカル依存関係
current ./navarch-project
```

### 基本的な使用法
```bash
# 依存関係をダウンロード
navarch pull

# ビルド実行
navarch build

# サービス起動
navarch up

# サービス停止
navarch down

# クリーンアップ
navarch clean
```

### 複数依存関係の例
```bash
# atlas.navarch（この記述順序で処理される）
env .env
env .env.local

vendor https://github.com/user/database      # 1番目
vendor https://github.com/user/api-server    # 2番目
vendor https://github.com/user/web-frontend  # 3番目

current ./custom-service                     # 4番目
current ./monitoring                         # 5番目

# 各vendor/currentディレクトリにatlas.navarchがある場合は再帰処理
# build/up: 1→2→3→4→5 の順で処理（再帰先も含む）
# down: 5→4→3→2→1 の順で処理（再帰先も含む）
```

### サブコマンド関数定義例
各ディレクトリの`atlas.navarch`でのサブコマンド関数定義:
```bash
#!/bin/bash
# サブコマンド関数を定義

build() {
    echo "Building web frontend..."
    npm install
    npm run build
}

up() {
    echo "Starting web frontend..."
    docker build -t frontend .
    docker run -d -p 3000:3000 --name frontend frontend
}

down() {
    echo "Stopping web frontend..."
    docker stop frontend
    docker rm frontend
}

clean() {
    echo "Cleaning up web frontend..."
    docker rmi frontend
    npm run clean
}
```

## 利点
- **シンプルな設定**: Bashファイルによる直感的な依存関係定義
- **GitHub統合**: vendorディレクティブによる簡単な外部依存関係管理
- **キャッシュ効率**: .cache以下での効率的な依存関係管理
- **柔軟性**: Bashスクリプトの表現力を活用
- **関数ベース**: サブコマンドを関数として定義し、再利用性が高い
- **関数管理**: `declare -f`による関数の動的保存・実行
- **順序制御**: atlas.navarchの記述順序による明確な処理順序
- **内部実装**: ディレクティブ関数は単純なリスト構築処理
- **再帰処理**: vendor/currentディレクトリのatlas.navarchも自動処理

## 実装方式

### Bash実装
- **実装形式**: 単一のBashスクリプトファイル
- **ファイル配置**: `src/navarch`
- **実行可能**: `chmod +x src/navarch`で実行権限付与

### ディレクトリ構造
```
project/
├── src/
│   └── navarch              # 単一のBashスクリプト実装
├── tests/
│   ├── test_navarch.bats    # Batsテストファイル
│   ├── test_pull.bats       # pullコマンドテスト
│   ├── test_build.bats      # buildコマンドテスト
│   └── fixtures/            # テスト用データ
└── README.md                # インストール手順含む
```

### テスト方式
- **テストフレームワーク**: Bats (Bash Automated Testing System)
- **テストファイル配置**: `tests/` ディレクトリ
- **テスト実行**: `bats tests/` でテスト実行

### インストール方式
ワンライナーでのインストールを提供:

```bash
# インストールコマンド例
curl -fsSL https://raw.githubusercontent.com/user/repo/main/install.sh | bash
```

インストールスクリプトの動作:
1. `src/navarch`をダウンロード
2. `/usr/local/bin/navarch`に配置
3. 実行権限を付与
4. PATH追加の案内表示

## 移行計画
1. **Rev1からRev2への移行**: 既存のNAVARCH_PATH環境変数からatlas.navarchへの変換
2. **キャッシュシステム実装**: .cache以下での依存関係管理機能
3. **GitHub統合**: vendorディレクティブによるリポジトリダウンロード機能
4. **再帰処理実装**: vendor/currentディレクトリ内のatlas.navarch自動検出・処理
5. **Bash実装**: 単一ファイルでのCLI実装
6. **テスト体制**: Batsによる自動テスト実装
7. **インストール体制**: curlベースのワンライナーインストール実装