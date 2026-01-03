---
description: Guidelines for the Flutter Domain and Data layers. Includes Repositories, Services, Models, DTOs, and error handling in the data layer. Use this when implementing business logic or data access.
alwaysApply: false
---
## 🎯 Domain Layer (Business Logic)

**Purpose**: Define business rules and domain models

**Components**:
- **Models**: Pure business entities (no dependencies)
- **Use Cases**: Business logic operations (optional for simpler apps)

**Rules**:
1. Models MUST be pure Dart classes
2. Models MUST NOT depend on Flutter SDK
3. Models MUST NOT depend on external packages (except code generation annotations like `freezed_annotation`)
4. Models SHOULD be immutable when possible
5. Models SHOULD use value equality (prefer `freezed` for this)

### Example Domain Model (with Freezed)

```dart
// ✅ CORRECT: Pure, immutable, uses Freezed for value equality and copyWith
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required BookingStatus status,
  }) = _Booking;

  // Custom getters/methods can be added by adding a private constructor
  const Booking._();

  bool get isActive => status == BookingStatus.confirmed || status == BookingStatus.pending;
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}
```

---

## 🎯 Data Layer (Data Access)

**Purpose**: Fetch, cache, and manage data from external sources

**Components**:
- **Repositories**: Coordinate data from multiple sources
- **Services**: Handle specific external APIs or system features
- **Data Models**: API-specific models with serialization

**Rules**:
1. Repositories MUST extend `BaseRepository` (if available)
2. Repositories MUST return `Result<T>` types (see `flutter_design_patterns.mdc`)
3. Repositories MUST handle all exceptions
4. Repositories SHOULD cache data when appropriate
5. Services MUST be injected into repositories
6. Services MUST NOT be used directly by ViewModels
7. Data models MUST include serialization (toJson/fromJson), prefer `json_serializable` or `freezed`

### Example Repository

```dart
// ✅ CORRECT: Uses Result pattern, handles errors, caches data
class BookingRepository {
  BookingRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;
  
  final ApiService _apiService;
  final CacheService _cacheService;
  
  /// Fetch all bookings for the current user
  Future<Result<List<Booking>>> getBookings() async {
    try {
      // Try cache first
      final cached = await _cacheService.getBookings();
      if (cached != null) return Result.ok(cached);
      
      // Fetch from API
      final response = await _apiService.get<List<dynamic>>('/bookings');
      final bookings = response
          .map((json) => BookingDto.fromJson(json).toDomain())
          .toList();
      
      // Update cache
      await _cacheService.saveBookings(bookings);
      
      return Result.ok(bookings);
    } on NetworkException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
```

### Example Data Model (DTO with JsonSerializable)

```dart
// ✅ CORRECT: Uses json_serializable for safe serialization
import 'package:json_annotation/json_annotation.dart';

part 'booking_dto.g.dart';

@JsonSerializable()
class BookingDto {
  const BookingDto({
    required this.id,
    required this.userId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
  
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String destination;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  final String status;
  
  factory BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$BookingDtoToJson(this);
  
  // Convert to domain model
  Booking toDomain() {
    return Booking(
      id: id,
      userId: userId,
      destination: destination,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      status: _parseStatus(status),
    );
  }
  
  // Create from domain model
  factory BookingDto.fromDomain(Booking booking) {
    return BookingDto(
      id: booking.id,
      userId: booking.userId,
      destination: booking.destination,
      startDate: booking.startDate.toIso8601String(),
      endDate: booking.endDate.toIso8601String(),
      status: booking.status.name,
    );
  }
  
  BookingStatus _parseStatus(String status) {
    // Helper implementation...
    return BookingStatus.values.firstWhere((e) => e.name == status, orElse: () => BookingStatus.pending);
  }
}
```

### Error Handling in Repositories

**Define custom exceptions** (NetworkException, ApiException, etc.) and handle them within repository methods, returning `Result.error`.
