import 'cities_areas_service.dart';
import 'models/city.dart';
import 'models/area.dart';
import 'logging.dart';

/// Static API for UAE City Areas plugin. Call directly without creating any object.
/// Uses the fixed API at https://api.softasium.com only.
///
/// Example:
/// ```dart
/// UAECityAreasPlugin.loggingEnabled = true;  // optional: enable plugin logging
/// final cities = await UAECityAreasPlugin.getCities();
/// final areas = await UAECityAreasPlugin.getAreasByCityId(cityId);
/// ```
class UAECityAreasPlugin {
  UAECityAreasPlugin._();

  static CitiesAreasService? _service;

  /// When true, the plugin logs actions to the console. Default is false.
  static bool get loggingEnabled => UaeCityAreasLogging.enable;
  static set loggingEnabled(bool value) => UaeCityAreasLogging.enable = value;

  static CitiesAreasService get _instance {
    _service ??= CitiesAreasService();
    return _service!;
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
