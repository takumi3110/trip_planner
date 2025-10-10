# `trip_planner` 実装計画書

このドキュメントは、`trip_planner`アプリを開発するための段階的なタスクリストです。

## ジャーナル

**2025/10/10**
**フェーズ1完了！**
- `flutter create`でプロジェクトを作成。
- `rm`コマンドで不要なボイラープレート（`lib/main.dart`, `test/`）を削除。
- `pubspec.yaml`の`description`と`version`を更新。
- `README.md`と`CHANGELOG.md`をプレースホルダーで作成。
- `git init`でGitリポジトリを初期化し、`main`ブランチに最初のコミットをプッシュ。
- **学び:** `flutter create`は空じゃないディレクトリでは失敗する。先に`DESIGN.md`とかを作っちゃってたから、`flutter create .` を実行して既存のファイルを上書き・統合する形にした。今後は先にプロジェクト作ってからドキュメントを追加するフローが良いかも！

**2025/10/10**
**フェーズ2完了！**
- `Trip`, `Itinerary`, `Activity` のデータモデルを作成。
- `TripRepository` のインターフェースを定義。
- ダミーデータを返す `MockTripDataSource` を実装。
- 作成したモデルとデータソースに対するユニットテストを追加し、すべてパスすることを確認。
- `dart fix`, `flutter analyze`, `dart format` を実行してコードの品質を担保。
- **学び:** `flutter test` を実行する前に、`test` ディレクトリと、その中に `pubspec.yaml` で定義されているパッケージ (`trip_planner`) への依存関係を解決するためのファイル構造が必要だった。

---

## フェーズ 1: プロジェクトのセットアップ

最初のステップとして、Flutterプロジェクトを作成し、基本的な設定を整えます。

- [x] `/Users/tak/IdeaProjects/trip_planner` ディレクトリに、`trip_planner` という名前で新しいFlutterプロジェクトを作成する。
- [x] `lib/main.dart` と `test/` ディレクトリ内の不要なサンプルコードを削除する。
- [x] `pubspec.yaml` を開き、`description` を「A new Flutter project that creates travel plans.」に更新し、バージョンを `0.1.0` に設定する。
- [x] `README.md` を作成し、簡単なプレースホルダー（例: `# trip_planner`）を記述する。
- [x] `CHANGELOG.md` を作成し、`0.1.0` の初期リリースノートを記述する。
- [x] これらの初期設定をGitの`main`ブランチにコミットする。

### 各タスク完了後のチェックリスト:
- [x] このフェーズで追加・変更したコードに対するユニットテストを作成する（今回はテスト削除なので対象外）。
- [x] `dart fix --apply` を実行してコードをクリーンアップする。
- [x] `flutter analyze` を実行し、問題を修正する。
- [x] `flutter test` を実行し、すべてのテストがパスすることを確認する。
- [x] `dart format .` を実行して、フォーマットを整える。
- [x] この`IMPLEMENTATION.md`ファイルを再読み込みし、変更がないか確認する。
- [x] `IMPLEMENTATION.md`のジャーナルを更新し、完了したタスクにチェックを入れる。
- [x] `git diff` で変更内容を確認し、ユーザーにコミットメッセージの承認を得る。
- [x] 承認後、変更をコミットする。

---

## フェーズ 2: データモデルとRepositoryの作成

アプリの核となるデータ構造と、データを扱うためのRepositoryパターンを実装します。

- [x] `lib/data/models/` ディレクトリを作成し、`trip.dart`, `itinerary.dart`, `activity.dart` の各モデルファイルを作成する。
- [x] `lib/data/repositories/` ディレクトリを作成し、`trip_repository.dart` ファイルに `TripRepository` の抽象クラス（インターフェース）を定義する。
- [x] `lib/data/sources/` ディレクトリを作成し、`mock_trip_data_source.dart` にダミーデータを返す `TripRepository` の実装クラスを作成する。

### 各タスク完了後のチェックリスト:
- [x] このフェーズで追加・変更したコードに対するユニットテストを作成する。
- [x] `dart fix --apply` を実行してコードをクリーンアップする。
- [x] `flutter analyze` を実行し、問題を修正する。
- [x] `flutter test` を実行し、すべてのテストがパスすることを確認する。
- [x] `dart format .` を実行して、フォーマットを整える。
- [x] この`IMPLEMENTATION.md`ファイルを再読み込みし、変更がないか確認する。
- [x] `IMPLEMENTATION.md`のジャーナルを更新し、完了したタスクにチェックを入れる。
- [x] `git diff` で変更内容を確認し、ユーザーにコミットメッセージの承認を得る。
- [x] 承認後、変更をコミットする。

---

## フェーズ 3: 画面遷移と旅行プラン作成機能の実装

画面遷移の仕組みを導入し、最初の機能である旅行プラン作成画面を作ります。

- [ ] `go_router` パッケージをプロジェクトに追加する。
- [ ] `lib/core/routing/app_router.dart` を作成し、アプリの画面遷移ルートを設定する。
- [ ] `lib/features/create_trip/view/create_trip_screen.dart` に、目的地や日付を入力するためのUIを実装する。
- [ ] `lib/features/create_trip/viewmodel/create_trip_viewmodel.dart` を作成し、入力フォームの状態を管理するロジックを実装する。
- [ ] `main.dart` を更新し、`go_router` を使ったナビゲーションを有効にする。

### 各タスク完了後のチェックリスト:
- [ ] このフェーズで追加・変更したコードに対するユニットテスト・ウィジェットテストを作成する。
- [ ] `dart fix --apply` を実行してコードをクリーンアップする。
- [ ] `flutter analyze` を実行し、問題を修正する。
- [ ] `flutter test` を実行し、すべてのテストがパスすることを確認する。
- [ ] `dart format .` を実行して、フォーマットを整える。
- [ ] この`IMPLEMENTATION.md`ファイルを再読み込みし、変更がないか確認する。
- [ ] `IMPLEMENTATION.md`のジャーナルを更新し、完了したタaskにチェックを入れる。
- [ ] `git diff` で変更内容を確認し、ユーザーにコミットメッセージの承認を得る。
- [ ] 承認後、変更をコミットする。

---

## フェーズ 4: 旅程詳細表示機能の実装

生成された旅行プランの詳細を表示する画面を実装します。

- [ ] `lib/features/trip_details/view/trip_details_screen.dart` に、旅程リストを表示するUIを実装する。
- [ ] `lib/features/trip_details/viewmodel/trip_details_viewmodel.dart` を作成し、`TripRepository` から旅程データを取得し、UIに渡すロジックを実装する。
- [ ] プラン作成画面から詳細画面へ遷移できるように `go_router` の設定を更新する。

### 各タスク完了後のチェックリスト:
- [ ] このフェーズで追加・変更したコードに対するユニットテスト・ウィジェットテストを作成する。
- [ ] `dart fix --apply` を実行してコードをクリーンアップする。
- [ ] `flutter analyze` を実行し、問題を修正する。
- [ ] `flutter test` を実行し、すべてのテストがパスすることを確認する。
- [ ] `dart format .` を実行して、フォーマットを整える。
- [ ] この`IMPLEMENTATION.md`ファイルを再読み込みし、変更がないか確認する。
- [ ] `IMPLEMENTATION.md`のジャーナルを更新し、完了したタスクにチェックを入れる。
- [ ] `git diff` で変更内容を確認し、ユーザーにコミットメッセージの承認を得る。
- [ ] 承認後、変更をコミットする。

---

## フェーズ 5: 最終仕上げ

アプリのドキュメントを整備し、最終確認を行います。

- [ ] `README.md` ファイルを更新し、アプリの概要、機能、使い方などを詳細に記述する。
- [ ] プロジェクトのルートに `GEMINI.md` ファイルを作成し、アプリの目的、アーキテクチャ、ファイル構成などを記述する。
- [ ] ユーザーにアプリ全体の動作とコードを確認してもらい、満足のいくものになっているか、修正が必要な点はないか最終レビューを依頼する。

---
タスクを完了した後、もしコード内に `TODO` を残したり、未実装の部分がある場合は、新しいタスクとしてここに追加し、後で忘れずに対応できるようにしてください。
