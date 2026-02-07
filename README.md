# UAE Cities & Areas for Flutter

A **Flutter** plugin for **UAE** **cities**, **areas**, and **locations**. Fetch all **emirates** and their **areas** from the UAE API with built-in persistent caching—ideal for location pickers, address forms, and region selection in Flutter apps.

## Features

- 🏙️ Fetch UAE **cities** and **emirates** with English and Arabic names
- 📍 Fetch **areas** and **locations** for any **emirate** or city
- 💾 Persistent storage caching (survives app restarts)
- 🔄 Force refresh option to bypass cache
- ⚡ Fast offline support with cached data
- 🎯 Simple and intuitive API for UAE locations in Flutter

## Installation

Add the UAE cities and areas plugin to your Flutter app's `pubspec.yaml`:

```yaml
dependencies:
  uae_city_areas:
    path: ../path/to/uae_city_areas  # or use git/pub.dev if published
  http: ^1.0.0  # Add version you want to use
  shared_preferences: ^2.2.0  # Add version you want to use
```

**Note:** The plugin doesn't specify dependency versions, so you must add `http` and `shared_preferences` with your preferred versions in your app's `pubspec.yaml`.

## Usage

### Basic Usage (no object creation)

Call the plugin directly via static methods:

```dart
import 'package:uae_city_areas/uae_city_areas.dart';

// Fetch cities (no need to create any object)
final cities = await UaeCityAreas.getCities();

// Fetch areas for a city
final areas = await UaeCityAreas.getAreasByCityId(cityId);
```

### Optional: Custom Configuration

Call once at app startup if you need a custom base URL or headers:

```dart
void main() {
  UaeCityAreas.configure(
    baseUrl: 'https://api.softasium.com',
    headers: {'Authorization': 'Bearer token'},
    cacheTTL: Duration(days: 7),
  );
  runApp(MyApp());
}
```

### Force Refresh

```dart
final cities = await UaeCityAreas.getCities(forceRefresh: true);
final areas = await UaeCityAreas.getAreasByCityId(cityId, forceRefresh: true);
```

### Cache Management

```dart
await UaeCityAreas.clearCache();
await UaeCityAreas.clearCitiesCache();
await UaeCityAreas.clearAreasCache(cityId);   // or null to clear all
```

### Error Handling

```dart
try {
  final cities = await UaeCityAreas.getCities();
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

### Logging

Logging is off by default. Enable it to print plugin actions (API calls, cache hits/misses) to the console:

```dart
import 'package:uae_city_areas/uae_city_areas.dart';

void main() {
  UaeCityAreas.loggingEnabled = true;  // Enable plugin logging
  runApp(MyApp());
}
```

## API

### UaeCityAreas (static – use this, no object creation)

Call these directly:

- `UaeCityAreas.getCities({bool forceRefresh = false})` - Fetch all cities/emirates
- `UaeCityAreas.getAreasByCityId(int cityId, {bool forceRefresh = false})` - Fetch areas for a city
- `UaeCityAreas.getAreasByCity(City city, {bool forceRefresh = false})` - Fetch areas by City object
- `UaeCityAreas.clearCache()` - Clear all cached data
- `UaeCityAreas.clearCitiesCache()` - Clear only cities cache
- `UaeCityAreas.clearAreasCache(int? cityId)` - Clear areas cache (specific city or all)
- `UaeCityAreas.configure(...)` - Optional one-time config (baseUrl, headers, cacheTTL)

### CitiesAreasService (optional)

For custom instances (e.g. multiple base URLs), create `CitiesAreasService()` and use its methods. Most apps can use `UaeCityAreas` static API only.

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

See the `example/` directory for a complete Flutter app demonstrating UAE cities, areas, and emirates (locations) selection.

Run the example:

```bash
cd example
flutter pub get
flutter run
```

## API Endpoints

The plugin uses the following endpoints for UAE emirates and areas:

- **Cities / Emirates**: `GET /api/geoemirates/get`
- **Areas / Locations**: `GET /api/geoemirates/GetAreasByEmirateId/{id}`

Base URL defaults to `https://api.softasium.com` but can be configured.

## License

See LICENSE file for details.
