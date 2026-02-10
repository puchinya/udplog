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
### iOS
- Compatible `Human Interface Guidelines`

### Others

## Code Style
- Use defining variables for colors/text styles.
- Extract complex widgets into smaller components.
