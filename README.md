# ontime

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Git のコミットメッセージの書き方

- 1 行目：変更内容の要約（タイトル、概要）
- 2 行目 ：空行
- 3 行目以降：変更した理由（内容、詳細）

## 1 行目

コミット種別と要約を書きます。フォーマットは以下とします。

[コミット種別]要約

### コミット種別

以下の中から適切な種別を選びます。

- fix：バグ修正
- add：新規（ファイル）機能追加
- update：機能修正（バグではない）
- remove：削除（ファイル）

### 要約

変更内容の概要を書きます。シンプルかつ分かりやすく。（難しい）
【例】削除フラグが更新されない不具合の修正

## 3 行目

変更した理由を出来るかぎり具体的に書きます。
【例】refs #110 更新 SQL の対象カラムに削除フラグが含まれていなかったため追加しました。

# Git フローについて

- develop：開発の起点になるブランチ
- feature：個々の機能の開発ブランチ
- staging：リリース直前のブランチ
- master：リリースされるブランチ
- hotfix：リリースされたコードの修正のためのブランチ
