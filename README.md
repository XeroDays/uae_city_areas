# UAE Cities & Areas for Flutter

A Flutter plugin for fetching cities/emirates and areas from the UAE API with built-in persistent caching support.

## Features

- 🏙️ Fetch cities/emirates with English and Arabic names
- 📍 Fetch areas for any city/emirate
- 💾 Persistent storage caching (survives app restarts)
- 🔄 Force refresh option to bypass cache
- ⚡ Fast offline support with cached data
- 🎯 Simple and intuitive API

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  uae_city_areas:
    path: ../path/to/uae_city_areas  # or use git/pub.dev if published
  http: ^1.0.0  # Add version you want to use
  shared_preferences: ^2.2.0  # Add version you want to use
```

**Note:** The plugin doesn't specify dependency versions, so you must add `http` and `shared_preferences` with your preferred versions in your app's `pubspec.yaml`.

## Usage

### Basic Usage

```dart
import 'package:uae_city_areas/uae_city_areas.dart';

// Create service instance
final citiesAreas = CitiesAreasService();

// Fetch cities
final cities = await citiesAreas.getCities();

// Fetch areas for a city
final areas = await citiesAreas.getAreasByCityId(cityId);
```

### With Custom Configuration

```dart
final citiesAreas = CitiesAreasService(
  baseUrl: 'https://api.softasium.com',  // Optional, has default
  headers: {'Authorization': 'Bearer token'},  // Optional
  cacheTTL: Duration(days: 7),  // Optional cache expiration
);
```

### Force Refresh

```dart
// Force refresh cities (bypass cache)
final cities = await citiesAreas.getCities(forceRefresh: true);

// Force refresh areas
final areas = await citiesAreas.getAreasByCityId(cityId, forceRefresh: true);
```

### Cache Management

```dart
// Clear all cache
await citiesAreas.clearCache();

// Clear only cities cache
await citiesAreas.clearCitiesCache();

// Clear areas cache for specific city
await citiesAreas.clearAreasCache(cityId);

// Clear all areas cache
await citiesAreas.clearAreasCache(null);
```

### Error Handling

```dart
try {
  final cities = await citiesAreas.getCities();
} on NetworkException catch (e) {
  // Handle network error
} on ApiException catch (e) {
  // Handle API error (e.statusCode, e.message)
} on ParseException catch (e) {
  // Handle parsing error
} on CitiesAreasException catch (e) {
  // Handle other plugin errors
}
```

## API

### CitiesAreasService

Main service class for fetching cities and areas.

#### Methods

- `Future<List<City>> getCities({bool forceRefresh = false})` - Fetch all cities/emirates
- `Future<List<Area>> getAreasByCityId(int cityId, {bool forceRefresh = false})` - Fetch areas for a city
- `Future<List<Area>> getAreasByCity(City city, {bool forceRefresh = false})` - Convenience method to fetch areas by City object
- `Future<void> clearCache()` - Clear all cached data
- `Future<void> clearCitiesCache()` - Clear only cities cache
- `Future<void> clearAreasCache(int? cityId)` - Clear areas cache (specific city or all)

### Models

#### City

```dart
class City {
  final int id;           // City/emirate ID
  final String name;      // English name
  final String nameArabic; // Arabic name
}
```

#### Area

```dart
class Area {
  final int id;          // Area ID
  final String name;     // Area name
  final int emirateId;    // ID of the emirate/city
}
```

### Exceptions

- `CitiesAreasException` - Base exception
- `NetworkException` - Network/connection errors
- `ApiException` - API errors (includes statusCode)
- `ParseException` - JSON parsing errors
- `CacheException` - Cache operation errors

## Caching

The plugin uses persistent storage caching with `shared_preferences`:

- **Default behavior**: Returns cached data if available, otherwise fetches from API
- **Force refresh**: Bypasses cache and fetches fresh data
- **TTL support**: Optional time-to-live for cache expiration
- **Offline support**: Works offline with cached data

Cache persists across app restarts, so subsequent launches are instant.

## Example

See the `example/` directory for a complete Flutter app demonstrating plugin usage.

Run the example:

```bash
cd example
flutter pub get
flutter run
```

## API Endpoints

The plugin uses the following endpoints:

- **Cities**: `GET /api/geoemirates/get`
- **Areas**: `GET /api/geoemirates/GetAreasByEmirateId/{id}`

Base URL defaults to `https://api.softasium.com` but can be configured.

## License

See LICENSE file for details.
