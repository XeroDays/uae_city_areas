import 'dart:convert';
import 'api_client.dart';
import '../models/city.dart';
import '../models/area.dart';
import '../errors/cities_areas_exceptions.dart';
import '../logging.dart';

/// API layer for cities and areas endpoints
class CitiesAreasApi {
  /// API client instance
  final ApiClient _client;

  /// Creates a CitiesAreasApi instance
  CitiesAreasApi(this._client);

  /// Fetches all cities/emirates from the API
  ///
  /// Throws [NetworkException] if network error occurs
  /// Throws [ApiException] if API returns error status code
  /// Throws [ParseException] if JSON parsing fails
  Future<List<City>> getCities() async {
    UaeCityAreasLogging.log('getCities: fetching from API');
    try {
      final response = await _client.get('/api/geoemirates/get');
      final jsonData = json.decode(response) as List;
      final cities = jsonData
          .map((item) => City.fromJson(item as Map<String, dynamic>))
          .toList();
      UaeCityAreasLogging.log('getCities: parsed ${cities.length} cities');
      return cities;
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      UaeCityAreasLogging.log('getCities: parse error $e');
      throw ParseException('Failed to parse cities response: $e');
    }
  }

  /// Fetches areas for a specific city/emirate by ID
  ///
  /// [cityId] - The ID of the city/emirate
  ///
  /// Throws [NetworkException] if network error occurs
  /// Throws [ApiException] if API returns error status code
  /// Throws [ParseException] if JSON parsing fails
  Future<List<Area>> getAreasByCityId(int cityId) async {
    UaeCityAreasLogging.log('getAreasByCityId: fetching for cityId=$cityId');
    try {
      final response =
          await _client.get('/api/geoemirates/GetAreasByEmirateId/$cityId');
      final jsonData = json.decode(response) as List;

      final areas = jsonData.map((item) {
        final areaJson = item as Map<String, dynamic>;
        if (!areaJson.containsKey('emirateId')) {
          areaJson['emirateId'] = cityId;
        }
        return Area.fromJson(areaJson);
      }).toList();
      UaeCityAreasLogging.log('getAreasByCityId: parsed ${areas.length} areas');
      return areas;
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      UaeCityAreasLogging.log('getAreasByCityId: parse error $e');
      throw ParseException('Failed to parse areas response: $e');
    }
  }
}
