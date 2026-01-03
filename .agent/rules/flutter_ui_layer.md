---
description: Guidelines for the Flutter UI Layer, including ViewModels, Views (Widgets), and state management. Use this when working on screens or ViewModels.
alwaysApply: false
---
## 🎯 UI Layer (Presentation)

**Purpose**: Display information and handle user interactions

**Components**:
- **Views (Widgets)**: Display UI, capture user input
- **ViewModels**: Hold UI state, expose data and commands

**Rules**:
1. Views MUST be as simple as possible
2. Views MUST NOT contain business logic
3. Views SHOULD be StatelessWidget when possible
4. ViewModels MUST extend `ChangeNotifier`
5. ViewModels MUST NOT import UI code
6. ViewModels MUST use repositories for data operations
7. All async operations MUST be wrapped in Commands (see `flutter_design_patterns.mdc`)

### Example Screen

```dart
// ✅ CORRECT: Simple, delegates everything to ViewModel
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});
  
  final HomeViewModel viewModel;
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();
  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    
    return Scaffold(
      body: ListenableBuilder(
        listenable: viewModel.loadData,
        builder: (context, child) {
          // Handle loading state
          if (viewModel.loadData.running) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Handle error state
          if (viewModel.loadData.error) {
            return ErrorIndicator(
              title: 'Failed to load data',
              onRetry: viewModel.loadData.execute,
            );
          }
          
          // Show data
          return child!;
        },
        child: ListView.builder(
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            return ItemTile(item: viewModel.items[index]);
          },
        ),
      ),
    );
  }
}
```

### Example ViewModel

```dart
// ✅ CORRECT: Manages UI state, uses repositories, exposes commands
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  }) : _bookingRepository = bookingRepository,
       _userRepository = userRepository {
    // Initialize commands
    loadData = Command0(_loadData)..execute();
    refreshData = Command0(_refreshData);
    deleteItem = Command1(_deleteItem);
  }
  
  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;
  
  // Commands for async operations
  late final Command0<void> loadData;
  late final Command0<void> refreshData;
  late final Command1<void, String> deleteItem;
  
  // Private state with public getters
  List<Booking> _items = [];
  List<Booking> get items => _items;
  
  User? _currentUser;
  User? get currentUser => _currentUser;
  
  // Command implementations
  Future<Result<void>> _loadData() async {
    final userResult = await _userRepository.getCurrentUser();
    final bookingsResult = await _bookingRepository.getBookings();
    
    if (userResult case Ok(:final value)) {
      _currentUser = value;
    }
    
    if (bookingsResult case Ok(:final value)) {
      _items = value;
    }
    
    return bookingsResult;
  }
  
  Future<Result<void>> _refreshData() async {
    return await _loadData();
  }
  
  Future<Result<void>> _deleteItem(String id) async {
    final result = await _bookingRepository.deleteBooking(id);
    
    if (result is Ok) {
      _items.removeWhere((item) => item.id == id);
    }
    
    return result;
  }
}
```

### Dependency Injection with Provider

**ViewModels at screen level**:

```dart
// Route configuration
GoRoute(
  path: '/home',
  builder: (context, state) {
    return HomeScreen(
      viewModel: HomeViewModel(
        bookingRepository: context.read<BookingRepository>(),
        userRepository: context.read<UserRepository>(),
      ),
    );
  },
),
```

### Displaying Errors in UI

```dart
Widget _buildErrorView(Exception error) {
  final (title, message, icon) = switch (error) {
    NoInternetException() => (
      'No Internet',
      'Please check your connection',
      Icons.wifi_off,
    ),
    TimeoutException() => (
      'Request Timeout',
      'The request took too long',
      Icons.access_time,
    ),
    // ... other cases
    _ => (
      'Error',
      'An unexpected error occurred',
      Icons.error_outline,
    ),
  };
  
  return ErrorView(
    icon: icon,
    title: title,
    message: message,
    onRetry: () => viewModel.loadData.execute(),
  );
}
```
