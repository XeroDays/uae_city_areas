# UAE Cities & Areas for Flutter

A **Flutter** plugin for **UAE** **cities**, **areas**, and **locations**. Fetch all **emirates** and their **areas** from the UAE API with built-in persistent caching—ideal for location pickers, address forms, and region selection in Flutter apps.

## Screenshots

<div style="display:flex; flex-wrap: wrap;">
  <code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/uae_city_areas/main/github-assets/uae%20city%20areas%20screen%201.jpg"></code>
  <code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/uae_city_areas/main/github-assets/uae%20city%20areas%20screen%202.jpg"></code>
  <code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/uae_city_areas/main/github-assets/uae%20city%20areas%20screen%203.jpg"></code>
  <code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/uae_city_areas/main/github-assets/uae%20city%20areas%20screen%204.jpg"></code>
</div>

## Features

- 🏙️ Fetch UAE **cities** and **emirates** with English and Arabic names
- 📍 Fetch **areas** and **locations** for any **emirate** or city
- 💾 Persistent storage caching (survives app restarts)
- 🔄 Force refresh option to bypass cache
- ⚡ Fast offline support with cached data
- 🎯 Simple and intuitive API for UAE locations in Flutter

## Usage

Use the **UAECityAreasPlugin** class: call its static methods directly (no object creation).

### Basic Usage

```dart
import 'package:uae_city_areas/uae_city_areas.dart';

// Fetch cities (no need to create any object)
final cities = await UAECityAreasPlugin.getCities();

// Fetch areas for a city
final areas = await UAECityAreasPlugin.getAreasByCityId(cityId);
```

### Force Refresh

```dart
final cities = await UAECityAreasPlugin.getCities(forceRefresh: true);
final areas = await UAECityAreasPlugin.getAreasByCityId(cityId, forceRefresh: true);
```

### Cache Management

```dart
await UAECityAreasPlugin.clearCache();
await UAECityAreasPlugin.clearCitiesCache();
await UAECityAreasPlugin.clearAreasCache(cityId);   // or null to clear all
```

### Error Handling

```dart
try {
  final cities = await UAECityAreasPlugin.getCities();
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
  UAECityAreasPlugin.loggingEnabled = true;  // Enable plugin logging
  runApp(MyApp());
}
```

## API

### UAECityAreasPlugin (static – use this, no object creation)

Call these directly:

- `UAECityAreasPlugin.getCities({bool forceRefresh = false})` - Fetch all cities/emirates
- `UAECityAreasPlugin.getAreasByCityId(int cityId, {bool forceRefresh = false})` - Fetch areas for a city
- `UAECityAreasPlugin.getAreasByCity(City city, {bool forceRefresh = false})` - Fetch areas by City object
- `UAECityAreasPlugin.clearCache()` - Clear all cached data
- `UAECityAreasPlugin.clearCitiesCache()` - Clear only cities cache
- `UAECityAreasPlugin.clearAreasCache(int? cityId)` - Clear areas cache (specific city or all)
- `UAECityAreasPlugin.loggingEnabled` - Get or set plugin logging (default: false)

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

## Example: Get cities and areas for a city

```dart
import 'package:uae_city_areas/uae_city_areas.dart';

Future<void> loadCitiesAndAreas() async {
  // 1. Get all cities (emirates)
  final cities = await UAECityAreasPlugin.getCities();
  if (cities.isEmpty) return;

  // 2. Pick a city (e.g. first one, or by user selection)
  final selectedCity = cities.first;

  // 3. Get areas for that city (by ID or by City object)
  final areas = await UAECityAreasPlugin.getAreasByCityId(selectedCity.id);
  // Or: final areas = await UAECityAreasPlugin.getAreasByCity(selectedCity);

  // Use the data
  for (final city in cities) {
    print('${city.name} (${city.nameArabic})');
  }
  for (final area in areas) {
    print('  - ${area.name}');
  }
}
```

With force refresh (bypass cache):

```dart
final cities = await UAECityAreasPlugin.getCities(forceRefresh: true);
final areas = await UAECityAreasPlugin.getAreasByCityId(cityId, forceRefresh: true);
```

## Example app

See the `example/` directory for a complete Flutter app with city and area dropdowns.

```bash
cd example
flutter pub get
flutter run
```

## License

MIT License

Copyright (c) 2026 Softasium Systems

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
