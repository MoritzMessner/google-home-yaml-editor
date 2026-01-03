---
description: Best practices, DOs and DON'Ts for Flutter development. Use this to ensure code quality and avoid common pitfalls.
alwaysApply: false
---
## ✅ Best Practices

### DO's

- ✅ **Use Result<T>** for all operations that can fail.
- ✅ **Wrap async operations in Commands** to handle loading/error states.
- ✅ **Keep views simple**; delegate logic to ViewModels.
- ✅ **Use private fields with public getters** in ViewModels to protect state.
- ✅ **Call notifyListeners()** after state changes in ViewModels.
- ✅ **Handle all error cases explicitly** (e.g., using switch on Result).
- ✅ **Use const constructors** for widgets and models where possible.
- ✅ **Dispose ViewModels** and streams when no longer needed.
- ✅ **Use Code Generation** for models (`freezed`) and serialization (`json_serializable`) to reduce boilerplate and ensure type safety.

### DON'Ts

- ❌ **Don't put business logic in views**.
- ❌ **Don't call repositories directly from views**; go through the ViewModel.
- ❌ **Don't import UI code in ViewModels** (no `flutter/material.dart` unless absolutely necessary for non-UI types, but generally avoid).
- ❌ **Don't throw exceptions in repositories**; return `Result.error` instead.
- ❌ **Don't forget to handle loading states** in the UI.
- ❌ **Don't use StatefulWidget** if the state can be managed by the ViewModel (unless it's purely ephemeral UI state like animation controllers).
- ❌ **Don't create ViewModels inside `build` method**.

### 💡 Tips for Success

1. **Start Simple**: Don't over-engineer.
2. **Be Consistent**: Stick to the patterns (Command, Result, MVVM).
3. **Write Tests**: Catch violations early.
4. **Refactor Incrementally**: Don't try to fix everything at once.
5. **Focus on Value**: Architecture supports the product.

### 🔄 Migration Guide (Summary)

1. **Extract Data Layer**: Create repositories, move API calls there.
2. **Implement Patterns**: Add Command/Result patterns.
3. **Refine ViewModels**: Move logic from Views to ViewModels.
4. **Clean Up Models**: Separate Domain vs Data (DTO) models.
5. **Add Tests**: Verify behavior.
