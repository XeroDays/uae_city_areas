import 'package:shared_preferences/shared_preferences.dart';
import 'api/api_client.dart';
import 'api/cities_areas_api.dart';
import 'cache/cities_areas_cache.dart';
import 'models/city.dart';
import 'models/area.dart';

/// Main service class for fetching cities and areas
class CitiesAreasService {
  /// API layer instance
  final CitiesAreasApi _api;

  /// Optional cache instance (lazy-loaded)
  CitiesAreasCache? _cache;

  /// Optional cache TTL (time-to-live)
  final Duration? cacheTTL;

  /// Base URL for API requests
  final String baseUrl;

  /// Optional headers for API requests
  final Map<String, String>? headers;

  /// Creates a CitiesAreasService instance
  ///
  /// [baseUrl] - Base URL for API requests (default: https://api.softasium.com)
  /// [headers] - Optional headers to include in all requests
  /// [cacheTTL] - Optional cache expiration time (default: no expiration)
  CitiesAreasService({
    this.baseUrl = 'https://api.softasium.com',
    this.headers,
    this.cacheTTL,
  }) : _api = CitiesAreasApi(ApiClient(baseUrl: baseUrl, headers: headers));

  /// Internal method to get cache instance (lazy-loaded)
  Future<CitiesAreasCache> _getCache() async {
    _cache ??= CitiesAreasCache(await SharedPreferences.getInstance());
    return _cache!;
  }

  /// Creates a CitiesAreasService instance with custom cache
  ///
  /// This constructor is useful for testing or when you want to provide
  /// a pre-initialized SharedPreferences instance.
  CitiesAreasService.withCache(
    SharedPreferences prefs, {
    this.baseUrl = 'https://api.softasium.com',
    this.headers,
    this.cacheTTL,
  })  : _api = CitiesAreasApi(ApiClient(baseUrl: baseUrl, headers: headers)),
        _cache = CitiesAreasCache(prefs);

  /// Fetches all cities/emirates
  ///
  /// [forceRefresh] - If true, bypasses cache and fetches fresh data from API
  ///
  /// Returns cached data if available (when forceRefresh is false),
  /// otherwise fetches from API and updates cache.
  Future<List<City>> getCities({bool forceRefresh = false}) async {
    final cache = await _getCache();
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cached = await cache.getCachedCities();
      if (cached != null) {
        // Check TTL if configured
        if (cacheTTL != null) {
          final timestamp = prefs.getInt('cities_areas_cache_cities_timestamp');
          if (timestamp != null) {
            final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
            if (cacheAge < cacheTTL!.inMilliseconds) {
              return cached;
            }
            // Cache expired, continue to fetch fresh data
          }
        } else {
          // No TTL, return cached data
          return cached;
        }
      }
    }

    // Fetch from API
    final cities = await _api.getCities();

    // Save to cache
    await cache.saveCities(cities);

    return cities;
  }

  /// Fetches areas for a specific city/emirate by ID
  ///
  /// [cityId] - The ID of the city/emirate
  /// [forceRefresh] - If true, bypasses cache and fetches fresh data from API
  ///
  /// Returns cached data if available (when forceRefresh is false),
  /// otherwise fetches from API and updates cache.
  Future<List<Area>> getAreasByCityId(
    int cityId, {
    bool forceRefresh = false,
  }) async {
    final cache = await _getCache();
    final prefs = await SharedPreferences.getInstance();

    if (!forceRefresh) {
      final cached = await cache.getCachedAreas(cityId);
      if (cached != null) {
        // Check TTL if configured
        if (cacheTTL != null) {
          final timestamp = prefs.getInt(
            'cities_areas_cache_areas_${cityId}_timestamp',
          );
          if (timestamp != null) {
            final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
            if (cacheAge < cacheTTL!.inMilliseconds) {
              return cached;
            }
            // Cache expired, continue to fetch fresh data
          }
        } else {
          // No TTL, return cached data
          return cached;
        }
      }
    }

    // Fetch from API
    final areas = await _api.getAreasByCityId(cityId);

    // Save to cache
    await cache.saveAreas(cityId, areas);

    return areas;
  }

  /// Fetches areas for a specific city
  ///
  /// Convenience method that calls [getAreasByCityId] with the city's ID
  Future<List<Area>> getAreasByCity(
    City city, {
    bool forceRefresh = false,
  }) {
    return getAreasByCityId(city.id, forceRefresh: forceRefresh);
  }

  /// Clears all cached data
  Future<void> clearCache() async {
    final cache = await _getCache();
    await cache.clearCache();
  }

  /// Clears only cities cache
  Future<void> clearCitiesCache() async {
    final cache = await _getCache();
    await cache.clearCitiesCache();
  }

  /// Clears areas cache for a specific city or all cities
  ///
  /// [cityId] - If provided, clears cache for that city only.
  ///            If null, clears cache for all cities.
  Future<void> clearAreasCache(int? cityId) async {
    final cache = await _getCache();
    await cache.clearAreasCache(cityId);
  }
}
