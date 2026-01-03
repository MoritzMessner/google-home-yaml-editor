# Cursor Rules Documentation

This directory contains comprehensive development guidelines for this Flutter project.

## 📄 Available Guides

### 1. `flutter_development_guide.md` (Project-Specific)
**Purpose**: Tailored rules and patterns specific to this H&L Hypnosen project

**Use when**:
- Working on this specific codebase
- Understanding existing code structure
- Following project conventions
- Learning about project-specific implementations

**Covers**:
- Project-specific directory structure
- Existing BaseRepository patterns
- Current state management approach
- Migration guidelines for this project
- Project-specific services and repositories

### 2. `flutter_architecture_guide.md` (Official Patterns)
**Purpose**: Comprehensive Flutter architecture patterns based on official Flutter docs

**Use when**:
- Starting new features from scratch
- Learning Flutter architecture best practices
- Understanding design patterns deeply
- Making architectural decisions
- Need detailed pattern implementations

**Covers**:
- Official Flutter architecture recommendations
- Command pattern (detailed)
- Result pattern (detailed)
- Optimistic State pattern
- Key-Value Storage pattern
- Complete implementation examples
- Testing strategies
- Error handling patterns

## 🎯 How to Use These Guides

### For New Features
1. Read `flutter_architecture_guide.md` to understand the patterns
2. Check `flutter_development_guide.md` for project-specific conventions
3. Implement following both sets of guidelines

### For Bug Fixes
1. Refer to `flutter_development_guide.md` first
2. Use `flutter_architecture_guide.md` if refactoring is needed

### For Code Review
1. Check against `flutter_development_guide.md` for project compliance
2. Verify patterns match `flutter_architecture_guide.md` recommendations

## 🔑 Key Principles (Both Guides)

### Architecture
- **MVVM Pattern**: Views + ViewModels + Repositories
- **Separation of Concerns**: Each layer has distinct responsibilities
- **Dependency Injection**: Use Provider for DI
- **Testability**: Each layer independently testable

### Required Patterns
1. **Command Pattern**: All async operations
2. **Result Pattern**: All operations that can fail
3. **Repository Pattern**: All data access
4. **Optimistic State**: For immediate feedback UX

### Layer Rules
- **UI Layer**: Only UI code, delegate to ViewModels
- **ViewModel**: State management, uses Commands, no UI imports
- **Repository**: Data access, returns Result<T>, handles errors
- **Service**: External APIs, injected into repositories

## 📊 Quick Decision Tree

```
Need to add code?
│
├─ Is it UI? → ui/<feature>/widgets/
│
├─ Is it state management? → ui/<feature>/view_model/
│
├─ Is it business logic? → domain/models/ or ViewModel method
│
├─ Is it data fetching? → data/repositories/
│
├─ Is it external API? → data/services/
│
└─ Is it utility? → utils/
```

## 🚨 Common Mistakes to Avoid

❌ **Don't** put business logic in views
❌ **Don't** call repositories from views directly
❌ **Don't** import UI code in ViewModels
❌ **Don't** throw exceptions in repositories (use Result)
❌ **Don't** forget to handle loading states
❌ **Don't** use StatefulWidget unless necessary

✅ **Do** use Commands for async operations
✅ **Do** return Result<T> from repositories
✅ **Do** keep views simple
✅ **Do** dispose resources properly
✅ **Do** handle all error cases
✅ **Do** write tests

## 📚 Learning Path

### Beginner
1. Read `flutter_development_guide.md` - "Architecture Overview"
2. Read `flutter_architecture_guide.md` - "Layer Responsibilities"
3. Study existing code examples in the project
4. Implement a simple feature following the patterns

### Intermediate
1. Deep dive into Command Pattern in `flutter_architecture_guide.md`
2. Deep dive into Result Pattern in `flutter_architecture_guide.md`
3. Study repository implementations in the project
4. Refactor existing code to follow patterns

### Advanced
1. Study all patterns in `flutter_architecture_guide.md`
2. Understand testing strategies
3. Implement complex features with multiple patterns
4. Contribute to architecture improvements

## 🔄 When Guides Conflict

If you find conflicting information:

1. **Project-specific conventions** in `flutter_development_guide.md` take precedence for this project
2. **Official patterns** in `flutter_architecture_guide.md` should be used for new implementations
3. **Gradually migrate** old code to match official patterns

## 📝 Updating These Guides

These guides should be living documents:

- Update `flutter_development_guide.md` when project-specific patterns change
- Update `flutter_architecture_guide.md` when Flutter official docs are updated
- Keep this README in sync with both guides
- Document any deviations from official patterns

## 🎓 Additional Resources

### Official Flutter
- [Flutter Docs](https://docs.flutter.dev)
- [Architecture Guide](https://docs.flutter.dev/app-architecture/guide)
- [Design Patterns](https://docs.flutter.dev/app-architecture/design-patterns)

### Community
- [Flutter Samples](https://github.com/flutter/samples)
- [Very Good Ventures Architecture](https://verygood.ventures/blog)
- [Reso Coder Architecture](https://resocoder.com)

---

**Remember**: Good architecture is about making code easy to understand, modify, and test. Follow these guides not blindly, but with understanding of *why* each pattern exists.

