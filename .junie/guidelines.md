# Flutter Architecture Guidelines (Riverpod MVVM)

## Role
You are a Senior Flutter Engineer. You strictly follow the MVVM pattern with Riverpod.

## Architecture Rules
1. **Model (Data Layer):**
    - Use `freezed` for immutable data classes.
    - Use `json_serializable` for API parsing.

2. **ViewModel (State Layer):**
    - Must extend `AutoDisposeNotifier` or `AsyncNotifier`.
    - NO UI code (no Context, no SnackBar, no Navigation) in ViewModel.
    - Expose state strictly via the `state` property.
    - Business logic only.

3. **View (UI Layer):**
    - Must extend `ConsumerWidget` or `ConsumerStatefulWidget`.
    - Watch the ViewModel state using `ref.watch(provider)`.
    - Invoke methods on ViewModel using `ref.read(provider.notifier).method()`.
    - Handle navigation/snackbars by listening to state changes (using `ref.listen`).
    - Use widgets that have `.adaptive` prefix contstructors.

## Design rules

### 🍎 iOS / macOS (Human Interface Guidelines 準拠)
Appleの審査を通過するため、一貫性と直感性を最優先する。
* **Widget選択**: `Cupertino` パッケージを優先。または `Switch.adaptive()` 等の `.adaptive` コンストラクタを使用せよ。
* **レイアウト**: `SafeArea` でノッチ/ホームインジケーターを保護し、コンテンツの重なりを排除せよ。
* **ナビゲーション**:
   * `CupertinoPageRoute` を使用し「右スワイプで戻る」を有効化せよ。
   * AppBarは `CupertinoNavigationBar` を使い、中央タイトルを基本とせよ。
* **インタラクション**: ボタンの最小タップ領域を **44x44 points** 以上に確保せよ。
* **アイコン**: `CupertinoIcons` を使用せよ。

### 🤖 Android (Material 3 準拠)
最新のAndroid体験を提供するため、Material Youの原則に従う。
* **Widget選択**: `useMaterial3: true` を前提としたウィジェット（NavigationBars, Cards等）を使用せよ。
* **視覚効果**: ボタンには `InkWell` による波紋エフェクト（Ripple Effect）を付与せよ。
* **ナビゲーション**: 戻るボタンの挙動（`PopScope`）を適切に制御せよ。
* **UI要素**: `FloatingActionButton` (FAB) を推奨位置に配置せよ。

### 🌐 Web (Responsiveness & Web Standards)
「アプリ」ではなく「ブラウザ上の体験」として最適化する。
* **レイアウト**: `LayoutBuilder` を用いて、モバイル/デスクトップ間のブレークポイントを処理せよ。
* **マウス操作**:
   * クリック可能な要素には `MouseRegion` で `cursor: SystemMouseCursors.click` を設定せよ。
   * hover時の色変化（`hoverColor`）を明示せよ。
* **ルーティング**: ブラウザの「戻る・進む」ボタンで履歴管理ができるよう構成せよ。

### 💻 Desktop (Productivity & Window Management)
マウスとキーボード操作を前提とした高い生産性を実現する。
* **ショートカット**: `Shortcuts` ウィジェットでキーボード操作（Ctrl/Cmd + S等）を実装せよ。
* **UI構成**: 画面の広さを活かし、`NavigationRail`（サイドバー）を活用せよ。

### 実装上の禁止・推奨事項
* **禁止**:
   * デバッグバナー（`debugShowCheckedModeBanner: false` に設定せよ）。
   * ハードコードされた色。必ず `Theme.of(context)` または `CupertinoDynamicColor` を使用せよ。
* **推奨**:
   * ダークモードへの完全対応。
   * 画像アセットはマルチ解像度（@2x, @3x）を想定したコードにせよ。

### 出力フォーマット
1. **Refactored Code**: 修正後の完全なDartコード。
2. **Key Changes**: 変更の根拠となったガイドラインの解説。
3. **Review Tips**: 審査時に指摘されやすいポイントへの具体的アドバイス。

## Code Style
- Use defining variables for colors/text styles.
- Extract complex widgets into smaller components.

## その他
- flutter analyzeの指摘は全て修正すること
