import 'cities_areas_service.dart';
import 'models/city.dart';
import 'models/area.dart';

/// Static API for UAE City Areas plugin. Call directly without creating any object.
///
/// Example:
/// ```dart
/// final cities = await UaeCityAreas.getCities();
/// final areas = await UaeCityAreas.getAreasByCityId(cityId);
/// ```
///
/// Optional: call [configure] once (e.g. in main()) to set base URL or headers.
class UaeCityAreas {
  UaeCityAreas._();

  static CitiesAreasService? _service;

  static CitiesAreasService get _instance {
    _service ??= CitiesAreasService();
    return _service!;
  }

  /// Configure the plugin (optional). Call once at app startup if you need custom base URL or headers.
  static void configure({
    String? baseUrl,
    Map<String, String>? headers,
    Duration? cacheTTL,
  }) {
    _service = CitiesAreasService(
      baseUrl: baseUrl ?? 'https://api.softasium.com',
      headers: headers,
      cacheTTL: cacheTTL,
    );
  }

  /// Fetches all cities/emirates. Uses cache unless [forceRefresh] is true.
  static Future<List<City>> getCities({bool forceRefresh = false}) {
    return _instance.getCities(forceRefresh: forceRefresh);
  }

  /// Fetches areas for the given city/emirate ID. Uses cache unless [forceRefresh] is true.
  static Future<List<Area>> getAreasByCityId(
    int cityId, {
    bool forceRefresh = false,
  }) {
    return _instance.getAreasByCityId(cityId, forceRefresh: forceRefresh);
  }

  /// Fetches areas for the given city. Uses cache unless [forceRefresh] is true.
  static Future<List<Area>> getAreasByCity(
    City city, {
    bool forceRefresh = false,
  }) {
    return _instance.getAreasByCity(city, forceRefresh: forceRefresh);
  }

  /// Clears all cached data.
  static Future<void> clearCache() => _instance.clearCache();

  /// Clears only cities cache.
  static Future<void> clearCitiesCache() => _instance.clearCitiesCache();

  /// Clears areas cache. Pass [cityId] to clear one city, or null to clear all.
  static Future<void> clearAreasCache(int? cityId) =>
      _instance.clearAreasCache(cityId);
}
