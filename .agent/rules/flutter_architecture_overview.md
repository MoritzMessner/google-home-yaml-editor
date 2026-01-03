---
description: High-level overview of the Flutter project architecture, directory structure, file naming conventions, and decision checklists. Use this to understand where code belongs.
alwaysApply: false
---
## 🏗️ Architecture Overview

### Three-Layer Architecture

```
┌─────────────────────────────────────────┐
│          UI LAYER (Presentation)        │
│  Views (Widgets) + ViewModels           │
│  - User interface                       │
│  - User interaction handling            │
│  - UI state management                  │
└─────────────────────────────────────────┘
                    ↓↑
┌─────────────────────────────────────────┐
│        DOMAIN LAYER (Business Logic)    │
│  Models + Use Cases                     │
│  - Business logic                       │
│  - Domain models                        │
│  - Application rules                    │
└─────────────────────────────────────────┘
                    ↓↑
┌─────────────────────────────────────────┐
│         DATA LAYER (Data Access)        │
│  Repositories + Services                │
│  - Data fetching                        │
│  - Data caching                         │
│  - External APIs                        │
└─────────────────────────────────────────┘
```

### Key Principles

1. **Separation of Concerns**: Each layer has a distinct responsibility
2. **Dependency Rule**: Dependencies point inward (UI → Domain → Data)
3. **Testability**: Each layer can be tested independently
4. **Scalability**: Easy to add features without breaking existing code
5. **Maintainability**: Clear structure makes code easy to navigate and modify

---

## 📁 Project Structure

### Required Directory Layout

```
lib/
├── ui/                                    # UI LAYER
│   ├── core/
│   │   ├── ui/                           # Shared widgets & components
│   │   ├── themes/                       # Theme definitions & styling
│   │   └── view_model/                   # Base/core view models
│   └── <feature>/                        # Feature-specific UI modules
│       ├── view_model/                   # Feature ViewModels
│       │   └── <feature>_view_model.dart
│       └── widgets/                      # Feature screens & widgets
│           └── <feature>_screen.dart
│
├── domain/                               # DOMAIN LAYER
│   └── models/                           # Pure business models
│       └── <model_name>.dart
│
├── data/                                 # DATA LAYER
│   ├── models/                           # API/Data models
│   │   ├── <model_name>_dto.dart        # Data transfer objects
│   │   └── responses/                    # API response wrappers
│   ├── repositories/                     # Data repositories
│   │   └── <feature>_repository.dart
│   └── services/                         # Application services
│       └── <service_name>_service.dart
│
├── utils/                                # Shared utilities
│   ├── command/                          # Command pattern classes
│   └── result/                           # Result pattern classes
│
├── routing/                              # Navigation & routing
└── main.dart                             # App entry point
```

### File Naming Conventions

| Type | Pattern | Example |
|---|---|---|
| Screen | `<feature>_screen.dart` | `home_screen.dart` |
| ViewModel | `<feature>_view_model.dart` | `home_view_model.dart` |
| Repository | `<feature>_repository.dart` | `booking_repository.dart` |
| Service | `<feature>_service.dart` | `audio_player_service.dart` |
| Domain Model | `<model_name>.dart` | `user.dart` |
| Data Model | `<model_name>_dto.dart` | `user_dto.dart` |
| Response Model | `<response>_response.dart` | `booking_list_response.dart` |

---

## 📊 Architecture Decision Checklist

When adding a new feature, ask yourself:

### Where should this code go?

- [ ] Is it displaying UI? → **ui/<feature>/widgets/**
- [ ] Is it managing UI state? → **ui/<feature>/view_model/**
- [ ] Is it a business rule? → **domain/models/** or ViewModel method
- [ ] Is it fetching data? → **data/repositories/**
- [ ] Is it accessing an external API? → **data/services/**
- [ ] Is it a shared utility? → **utils/**

### How should dependencies be injected?

- [ ] Is it a singleton service? → **Provider in main.dart**
- [ ] Is it a repository? → **ProxyProvider in main.dart**
- [ ] Is it a ViewModel? → **Created at route level, passed to screen**
