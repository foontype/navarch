# NAVARCH 実装機能TODOリスト

## 実装概要
NAVARCH.mdの設計に基づいて、Bashベースの単一スクリプトとしてNAVARCH CLIシステムを実装する。

## フェーズ1: 基本構造とコア機能

### 1.1 プロジェクト構造の構築
- [ ] `src/navarch`スクリプトファイルの作成
- [ ] 基本的なCLIオプション解析機能の実装
- [ ] ヘルプメッセージとバージョン表示機能の実装

### 1.2 atlas.navarch処理エンジンの実装
- [ ] `atlas.navarch`ファイルの検索機能
- [ ] ディレクティブ関数（env、vendor、current）の動的定義
- [ ] `atlas.navarch`のsource実行によるディレクティブ収集
- [ ] 各ディレクティブ関数内でのリスト構築機能
- [ ] 記述順序の保持機能

### 1.3 基本サブコマンドの実装
- [ ] サブコマンド（pull、build、up、down、clean）の骨格実装
- [ ] 各サブコマンドのヘルプ機能

## フェーズ2: pullコマンドとvendor機能

### 2.1 vendorディレクティブの処理
- [ ] GitHub URLの解析（リポジトリ名、ブランチ/タグ抽出）
- [ ] `.cache`ディレクトリ構造の作成
- [ ] gitコマンドによるリポジトリのクローン機能

### 2.2 キャッシュ管理
- [ ] 既存キャッシュの検出と更新機能
- [ ] キャッシュの整合性チェック
- [ ] エラーハンドリング（ネットワークエラー、権限エラー等）

### 2.3 pullコマンドの完成
- [ ] vendorディレクティブの一括処理
- [ ] 進捗表示機能
- [ ] 詳細ログ出力機能

## フェーズ3: 再帰処理とサブコマンド実行

### 3.1 再帰的atlas.navarch処理
- [ ] vendor/currentディレクトリ内の`atlas.navarch`検出
- [ ] 依存関係ツリーの構築
- [ ] 循環依存の検出とエラーハンドリング

### 3.2 サブコマンド関数の実行エンジン
- [ ] 各`atlas.navarch`からの関数定義抽出（`declare -f`活用）
- [ ] 関数の一時保存と実行順序管理
- [ ] 実行時のエラーハンドリングと継続/停止制御

### 3.3 build/up/down/cleanコマンドの実装
- [ ] 記述順序での実行（build/up）
- [ ] 逆順実行（down/clean）
- [ ] 各プロジェクトでの関数実行
- [ ] 実行結果のログ出力

## フェーズ4: 環境変数とcurrent機能

### 4.1 envディレクティブの処理
- [ ] `.env`ファイルの読み込み機能
- [ ] 環境変数の設定と継承
- [ ] 複数環境ファイルの優先順位処理

### 4.2 currentディレクティブの処理
- [ ] ローカルパスの解決と検証
- [ ] 相対パス/絶対パスの正規化
- [ ] ディレクトリ存在チェック

## フェーズ5: テスト実装

### 5.1 テスト環境の構築
- [ ] `tests/`ディレクトリの作成
- [ ] Batsテストファイルの作成
- [ ] テスト用フィクスチャの準備

### 5.2 ユニットテストの実装
- [ ] `test_navarch.bats`: 基本機能テスト
- [ ] `test_pull.bats`: pullコマンドテスト
- [ ] `test_build.bats`: buildコマンドテスト
- [ ] 各ディレクティブ機能のテスト

### 5.3 統合テストの実装
- [ ] 実際のGitHubリポジトリを使用したpullテスト
- [ ] 複数依存関係での実行順序テスト
- [ ] エラーケースの網羅的テスト

## フェーズ6: インストール体制とドキュメント

### 6.1 インストールスクリプトの作成
- [ ] `install.sh`の実装
- [ ] curl経由でのワンライナーインストール
- [ ] 権限チェックとエラーハンドリング

### 6.2 ドキュメントの整備
- [ ] README.mdの詳細化
- [ ] 使用例の充実
- [ ] トラブルシューティングガイド

## 技術的実装項目

### メイン・CLI制御関数
- [ ] `main()`: CLIのメインエントリーポイント
- [ ] `parse_args()`: コマンドライン引数の解析
- [ ] `show_help()`: ヘルプメッセージの表示
- [ ] `show_version()`: バージョン情報の表示

### atlas.navarch処理エンジン
- [ ] `find_atlas_navarch()`: atlas.navarchファイルの検索
- [ ] `define_directive_functions()`: ディレクティブ関数の動的定義
- [ ] `source_atlas_navarch()`: atlas.navarchファイルのsource実行
- [ ] `build_dependency_tree()`: 依存関係ツリーの構築

### ディレクティブ関数（動的定義）
- [ ] `env()`: 環境変数ファイル指定（動的定義される関数）
- [ ] `vendor()`: GitHub依存関係指定（動的定義される関数）
- [ ] `current()`: ローカル依存関係指定（動的定義される関数）

### 関数実行エンジン
- [ ] `load_functions()`: atlas.navarchからサブコマンド関数を抽出
- [ ] `execute_subcommand()`: 指定サブコマンドの実行制御
- [ ] `execute_in_order()`: プロジェクトリストの順序実行制御

### サブコマンド実装関数
- [ ] `cmd_pull()`: pullサブコマンドの実装
- [ ] `cmd_build()`: buildサブコマンドの実装
- [ ] `cmd_up()`: upサブコマンドの実装
- [ ] `cmd_down()`: downサブコマンドの実装
- [ ] `cmd_clean()`: cleanサブコマンドの実装

### リポジトリ・キャッシュ管理
- [ ] `clone_repository()`: GitHubリポジトリのクローン実行
- [ ] `parse_github_url()`: GitHub URLの解析
- [ ] `create_cache_dir()`: キャッシュディレクトリ構造の作成
- [ ] `update_cache()`: 既存キャッシュの更新処理
- [ ] `check_cache_integrity()`: キャッシュの整合性チェック

### 環境変数管理
- [ ] `load_env_files()`: 環境ファイルの読み込み
- [ ] `set_environment()`: 環境変数の設定

### 再帰処理
- [ ] `detect_recursive_atlas()`: 依存ディレクトリ内のatlas.navarch検出
- [ ] `detect_circular_dependency()`: 循環依存の検出
- [ ] `process_recursively()`: 再帰的atlas.navarch処理

### パス・検証ユーティリティ
- [ ] `validate_path()`: パスの検証
- [ ] `normalize_path()`: パスの正規化
- [ ] `resolve_relative_path()`: 相対パスの解決

### ログ・エラーハンドリング
- [ ] `log()`: ログ出力
- [ ] `error()`: エラー処理とプログラム終了
- [ ] `warn()`: 警告メッセージ出力
- [ ] `debug()`: デバッグログ出力

### 進捗・結果表示
- [ ] `show_progress()`: 進捗状況の表示
- [ ] `report_results()`: 実行結果のレポート

## グローバル変数の実装
- [ ] `NAVARCH_VERSION`: navarchのバージョン番号
- [ ] `DEBUG_MODE`: デバッグモードフラグ (0/1)
- [ ] `VERBOSE_MODE`: 詳細出力モードフラグ (0/1)
- [ ] `PROJECT_ROOT`: プロジェクトのルートディレクトリパス
- [ ] `ENV_LIST[]`: env()で収集された環境ファイルパスのリスト
- [ ] `VENDOR_LIST[]`: vendor()で収集されたリポジトリ情報のリスト
- [ ] `CURRENT_LIST[]`: current()で収集されたローカルパスのリスト
- [ ] `PROJECT_LIST[]`: 実行順序でプロジェクト情報を格納した配列

## 実装優先順位（推奨）
1. **基盤関数**: ログ・エラーハンドリング、パス・検証ユーティリティ
2. **CLI制御**: メイン関数、引数解析、ヘルプ・バージョン表示
3. **atlas.navarch処理**: ファイル検索、ディレクティブ関数定義、source実行
4. **リポジトリ管理**: GitHub URL解析、キャッシュ管理、クローン機能
5. **pullコマンド**: 基本的なvendor処理の実装
6. **関数実行エンジン**: サブコマンド関数の抽出・実行
7. **他のサブコマンド**: build、up、down、clean
8. **再帰処理**: 依存関係の再帰処理、循環依存検出
9. **環境変数管理**: env処理の実装
10. **進捗・結果表示**: ユーザビリティ向上機能

## 品質保証目標
- [ ] 全機能のユニットテスト: 90%以上
- [ ] 主要ユースケースの統合テスト: 100%
- [ ] エラーケースのテスト: 80%以上
- [ ] POSIX互換性の確保
- [ ] セキュリティ考慮（パス注入等）
- [ ] エラーハンドリングの適切性
- [ ] 可読性とメンテナンス性

## リリース計画
### v1.0.0 (MVP)
- [ ] 基本的なpull、build、up、down、clean機能
- [ ] シンプルなatlas.navarch処理
- [ ] 基本的なエラーハンドリング

### v1.1.0 (機能拡張)
- [ ] 高度な再帰処理
- [ ] 詳細ログ機能
- [ ] パフォーマンス最適化

### v1.2.0 (安定化)
- [ ] 包括的テストスイート
- [ ] ドキュメントの充実
- [ ] エラーハンドリングの強化