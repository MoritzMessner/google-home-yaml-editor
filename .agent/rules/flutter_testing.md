---
alwaysApply: false
---
## 🧪 Testing Strategy

### Unit Test: ViewModels

Test that the ViewModel correctly updates its state (and Commands) in response to actions.

```dart
void main() {
  group('HomeViewModel', () {
    late HomeViewModel viewModel;
    late MockBookingRepository mockRepo;
    
    setUp(() {
      mockRepo = MockBookingRepository();
      viewModel = HomeViewModel(bookingRepository: mockRepo, ...);
    });
    
    test('loads bookings successfully', () async {
      when(mockRepo.getBookings()).thenAnswer((_) async => Result.ok(bookings));
      await viewModel.loadData.execute();
      expect(viewModel.items, bookings);
      expect(viewModel.loadData.completed, true);
    });
    
    test('handles error', () async {
      when(mockRepo.getBookings()).thenAnswer((_) async => Result.error(Exception()));
      await viewModel.loadData.execute();
      expect(viewModel.loadData.error, true);
    });
  });
}
```

### Unit Test: Repositories

Test that the Repository correctly coordinates between Services (API, Cache) and handles errors.

```dart
void main() {
  group('BookingRepository', () {
    // ... setup mocks
    
    test('returns cached data when available', () async {
      when(mockCache.getBookings()).thenAnswer((_) async => cachedBookings);
      final result = await repository.getBookings();
      expect((result as Ok).value, cachedBookings);
      verifyNever(mockApi.get(any));
    });
    
    test('fetches from API when cache is empty', () async {
      when(mockCache.getBookings()).thenAnswer((_) async => null);
      when(mockApi.get('/bookings')).thenAnswer((_) async => apiResponse);
      final result = await repository.getBookings();
      expect(result, isA<Ok<List<Booking>>>());
      verify(mockApi.get('/bookings')).called(1);
    });
  });
}
```

### Widget Tests

Test UI rendering in different states (Loading, Error, Data).

```dart
testWidgets('shows loading indicator', (tester) async {
  when(mockViewModel.loadData).thenReturn(MockCommand()..running = true);
  await tester.pumpWidget(MaterialApp(home: HomeScreen(viewModel: mockViewModel)));
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```
