# プルリクエストの作り方
1. 既存のプルリクエストの状態を確認
   ```
   mcp__github__list_pull_requests
   ```
   マージ済みの場合は新しいプルリクエストを作成

2. 新しいブランチを作成
   ```bash
   git checkout -b ブランチ名
   ```

3. ブランチをプッシュ
   ```bash
   git push -u origin ブランチ名
   ```

4. GitHub MCP serverツールでPR作成
   ```
   mcp__github__create_pull_request
   ```