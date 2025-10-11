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

**2025/10/10**
**フェーズ3完了！**
- `go_router`を導入し、基本的な画面遷移の仕組みを構築。
- `CreateTripScreen`のUIと、その状態を管理する`CreateTripViewModel`を作成。
- `ListenableBuilder`を使ってUIとViewModelを連携させた。
- `CreateTripScreen`のウィジェットテストを追加し、画面が正しく表示されることを確認。
- `flutter analyze`で`print`文の使用が検出されたため、修正した。
- **学び:** `StatefulWidget`の`initState`でViewModelを初期化し、`dispose`で破棄するライフサイクル管理が重要。`TextEditingController`の`addListener`を使うことで、UIの入力をリアルタイムでViewModelに伝えることができた。

**2025/10/11**
**フェーズ4完了！**
- `lib/features/trip_details/view/trip_details_screen.dart` に、旅程リストを表示するUIを実装。
- `lib/features/trip_details/viewmodel/trip_details_viewmodel.dart` を作成し、`TripRepository`
  から旅程データを取得し、UIに渡すロジックを実装。
- プラン作成画面から詳細画面へ遷移できるように `go_router` の設定を更新。
- `provider` パッケージを導入し、`TripRepository` を提供するように `main.dart` を修正。
- `Activity` モデルの `time` フィールドを `DateTime` から `TimeOfDay` に変更し、関連するテストファイルと
  `mock_trip_data_source.dart` を修正。
- `trip_details_screen_test.dart` のテストを修正し、`ProviderNotFoundException` や `CircularProgressIndicator` が見つからない問題、
  `TimeOfDay.format` のロケール依存の問題を解決。
- `dart fix`, `flutter analyze`, `dart format` を実行してコードの品質を担保。
- **学び:** テスト環境での `Provider` の設定順序や、`TimeOfDay.format` のロケール・システム設定依存性、`mocktail` を使った
  `ViewModel` のテスト方法など、多くのことを学んだ！特に `await tester.pumpAndSettle()` の重要性を再認識したよ！

**2025/10/11**
**フェーズ5完了！**
- `README.md` ファイルを更新し、アプリの概要、機能、使い方などを詳細に記述する。
- プロジェクトのルートに `GEMINI.md` ファイルを作成し、アプリの目的、アーキテクチャ、ファイル構成などを記述する。
- ユーザーにアプリ全体の動作とコードを確認してもらい、満足のいくものになっているか、修正が必要な点はないか最終レビューを依頼する。

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

- [x] `go_router` パッケージをプロジェクトに追加する。
- [x] `lib/core/routing/app_router.dart` を作成し、アプリの画面遷移ルートを設定する。
- [x] `lib/features/create_trip/view/create_trip_screen.dart` に、目的地や日付を入力するためのUIを実装する。
- [x] `lib/features/create_trip/viewmodel/create_trip_viewmodel.dart` を作成し、入力フォームの状態を管理するロジックを実装する。
- [x] `main.dart` を更新し、`go_router` を使ったナビゲーションを有効にする。

### 各タスク完了後のチェックリスト:
- [x] このフェーズで追加・変更したコードに対するユニットテスト・ウィジェットテストを作成する。
- [x] `dart fix --apply` を実行してコードをクリーンアップする。
- [x] `flutter analyze` を実行し、問題を修正する。
- [x] `flutter test` を実行し、すべてのテストがパスすることを確認する。
- [x] `dart format .` を実行して、フォーマットを整える。
- [x] この`IMPLEMENTATION.md`ファイルを再読み込みし、変更がないか確認する。
- [x] `IMPLEMENTATION.md`のジャーナルを更新し、完了したタスクにチェックを入れる。
- [x] `git diff` で変更内容を確認し、ユーザーにコミットメッセージの承認を得る。
- [x] 承認後、変更をコミットする。

---

## フェーズ 4: 旅程詳細表示機能の実装

生成された旅行プランの詳細を表示する画面を実装します。

- [x] `lib/features/trip_details/view/trip_details_screen.dart` に、旅程リストを表示するUIを実装する。
- [x] `lib/features/trip_details/viewmodel/trip_details_viewmodel.dart` を作成し、`TripRepository` から旅程データを取得し、UIに渡すロジックを実装する。
- [x] プラン作成画面から詳細画面へ遷移できるように `go_router` の設定を更新する。

### 各タスク完了後のチェックリスト:
- [x] このフェーズで追加・変更したコードに対するユニットテスト・ウィジェットテストを作成する。
- [x] `dart fix --apply` を実行してコードをクリーンアップする。
- [x] `flutter analyze` を実行し、問題を修正する。
- [x] `flutter test` を実行し、すべてのテストがパスすることを確認する。
- [x] `dart format .` を実行して、フォーマットを整える。
- [x] この`IMPLEMENTATION.md`ファイルを再読み込みし、変更がないか確認する。
- [x] `IMPLEMENTATION.md`のジャーナルを更新し、完了したタスクにチェックを入れる。
- [ ] `git diff` で変更内容を確認し、ユーザーにコミットメッセージの承認を得る。
- [ ] 承認後、変更をコミットする。

---

## フェーズ 5: 最終仕上げ

アプリのドキュメントを整備し、最終確認を行います。

- [x] `README.md` ファイルを更新し、アプリの概要、機能、使い方などを詳細に記述する。
- [x] プロジェクトのルートに `GEMINI.md` ファイルを作成し、アプリの目的、アーキテクチャ、ファイル構成などを記述する。
- [x] ユーザーにアプリ全体の動作とコードを確認してもらい、満足のいくものになっているか、修正が必要な点はないか最終レビューを依頼する。

---
タスクを完了した後、もしコード内に `TODO` を残したり、未実装の部分がある場合は、新しいタスクとしてここに追加し、後で忘れずに対応できるようにしてください。
