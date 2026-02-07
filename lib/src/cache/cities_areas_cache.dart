import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city.dart';
import '../models/area.dart';
import '../errors/cities_areas_exceptions.dart';

/// Cache keys
class _CacheKeys {
  static const String cities = 'cities_areas_cache_cities';
  static const String citiesTimestamp = 'cities_areas_cache_cities_timestamp';
  static String areas(int cityId) => 'cities_areas_cache_areas_$cityId';
  static String areasTimestamp(int cityId) =>
      'cities_areas_cache_areas_${cityId}_timestamp';
}

/// Persistent storage cache for cities and areas
class CitiesAreasCache {
  /// SharedPreferences instance
  final SharedPreferences _prefs;

  /// Creates a CitiesAreasCache instance
  CitiesAreasCache(this._prefs);

  /// Gets cached cities from storage
  ///
  /// Returns null if no cache exists
  Future<List<City>?> getCachedCities() async {
    try {
      final citiesJson = _prefs.getString(_CacheKeys.cities);
      if (citiesJson == null) {
        return null;
      }

      final jsonData = json.decode(citiesJson) as Map<String, dynamic>;
      final citiesList = jsonData['cities'] as List;

      return citiesList
          .map((item) => City.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to read cached cities: $e');
    }
  }

  /// Saves cities to cache with current timestamp
  Future<void> saveCities(List<City> cities) async {
    try {
      final cacheData = {
        'cities': cities.map((city) => city.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _prefs.setString(
        _CacheKeys.cities,
        json.encode(cacheData),
      );
      await _prefs.setInt(
        _CacheKeys.citiesTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Failed to save cities to cache: $e');
    }
  }

  /// Gets cached areas for a specific city from storage
  ///
  /// [cityId] - The ID of the city/emirate
  ///
  /// Returns null if no cache exists
  Future<List<Area>?> getCachedAreas(int cityId) async {
    try {
      final areasJson = _prefs.getString(_CacheKeys.areas(cityId));
      if (areasJson == null) {
        return null;
      }

      final jsonData = json.decode(areasJson) as Map<String, dynamic>;
      final areasList = jsonData['areas'] as List;

      return areasList
          .map((item) => Area.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to read cached areas: $e');
    }
  }

  /// Saves areas for a specific city to cache with current timestamp
  Future<void> saveAreas(int cityId, List<Area> areas) async {
    try {
      final cacheData = {
        'emirateId': cityId,
        'areas': areas.map((area) => area.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _prefs.setString(
        _CacheKeys.areas(cityId),
        json.encode(cacheData),
      );
      await _prefs.setInt(
        _CacheKeys.areasTimestamp(cityId),
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Failed to save areas to cache: $e');
    }
  }

  /// Clears all cached data
  Future<void> clearCache() async {
    try {
      final keys = _prefs
          .getKeys()
          .where((key) => key.startsWith('cities_areas_cache_'))
          .toList();

      for (final key in keys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  /// Clears only cities cache
  Future<void> clearCitiesCache() async {
    try {
      await _prefs.remove(_CacheKeys.cities);
      await _prefs.remove(_CacheKeys.citiesTimestamp);
    } catch (e) {
      throw CacheException('Failed to clear cities cache: $e');
    }
  }

  /// Clears areas cache for a specific city or all cities
  ///
  /// [cityId] - If provided, clears cache for that city only.
  ///            If null, clears cache for all cities.
  Future<void> clearAreasCache(int? cityId) async {
    try {
      if (cityId != null) {
        await _prefs.remove(_CacheKeys.areas(cityId));
        await _prefs.remove(_CacheKeys.areasTimestamp(cityId));
      } else {
        // Clear all area caches
        final keys = _prefs
            .getKeys()
            .where((key) =>
                key.startsWith('cities_areas_cache_areas_') &&
                !key.contains('timestamp'))
            .toList();

        for (final key in keys) {
          await _prefs.remove(key);
          // Also remove corresponding timestamp
          final timestampKey = '${key}_timestamp';
          await _prefs.remove(timestampKey);
        }
      }
    } catch (e) {
      throw CacheException('Failed to clear areas cache: $e');
    }
  }
}
