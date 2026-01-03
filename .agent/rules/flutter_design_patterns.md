---
description: Reusable design patterns for Flutter architecture: Command, Result, Optimistic State, and Key-Value Storage. Use this when implementing async operations or shared utilities.
alwaysApply: false
---
## 🎨 Design Patterns

### 1. Command Pattern

**Purpose**: Wrap async operations to handle loading, success, and error states automatically.

**Use for**: Async user actions, loading data, form submissions.

**Implementation**:

```dart
abstract class Command<T> extends ChangeNotifier {
  Command();
  bool _running = false;
  bool get running => _running;
  Result<T>? _result;
  Result<T>? get result => _result;
  bool get error => _result is Error;
  bool get completed => _result is Ok;
  void clearResult() { _result = null; notifyListeners(); }
}

class Command0<T> extends Command<T> {
  Command0(this._action);
  final Future<Result<T>> Function() _action;
  Future<void> execute() async {
    if (_running) return;
    _running = true; _result = null; notifyListeners();
    try { _result = await _action(); } finally { _running = false; notifyListeners(); }
  }
}

class Command1<T, A> extends Command<T> {
  Command1(this._action);
  final Future<Result<T>> Function(A) _action;
  Future<void> execute(A argument) async {
    if (_running) return;
    _running = true; _result = null; notifyListeners();
    try { _result = await _action(argument); } finally { _running = false; notifyListeners(); }
  }
}
```

### 2. Result Pattern

**Purpose**: Explicit error handling type.

**Use for**: Repository methods, potentially failing service methods.

**Implementation**:

```dart
sealed class Result<T> {
  const Result();
  factory Result.ok(T value) = Ok._;
  factory Result.error(Exception error) = Error._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);
  final T value;
}

final class Error<T> extends Result<T> {
  const Error._(this.error);
  final Exception error;
}
```

### 3. Optimistic State Pattern

**Purpose**: Update UI immediately before server confirmation.

**Use for**: Likes, favorites, toggles.

```dart
Future<void> toggleFavorite(String id) async {
  final wasFavorite = _favoriteIds.contains(id);
  // Optimistically update
  if (wasFavorite) _favoriteIds.remove(id); else _favoriteIds.add(id);
  notifyListeners();
  
  final result = await _repository.setFavorite(id, !wasFavorite);
  
  // Rollback on failure
  if (result is Error) {
    if (wasFavorite) _favoriteIds.add(id); else _favoriteIds.remove(id);
    notifyListeners();
    // Show error...
  }
}
```

### 4. Key-Value Storage Pattern

**Purpose**: Persist simple preferences locally.

**Use for**: Theme, settings, language.

Use `SharedPreferences` wrapped in a Service class (e.g., `SharedPreferencesService`), then accessed via a `SettingsRepository`.
