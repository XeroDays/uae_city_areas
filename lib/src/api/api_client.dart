import 'package:http/http.dart' as http;
import '../errors/cities_areas_exceptions.dart';
import '../logging.dart';

/// Low-level HTTP client for making API requests
class ApiClient {
  /// Base URL for API requests
  final String baseUrl;

  /// Optional headers to include in all requests
  final Map<String, String>? headers;

  /// Creates an ApiClient instance
  ApiClient({
    required this.baseUrl,
    this.headers,
  });

  /// Makes a GET request to the specified endpoint
  ///
  /// Throws [NetworkException] if network error occurs
  /// Throws [ApiException] if API returns error status code
  Future<String> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    UaeCityAreasLogging.log('API GET $uri');
    try {
      final requestHeaders = <String, String>{};

      if (headers != null) {
        requestHeaders.addAll(headers!);
      }

      final response = await http.get(uri, headers: requestHeaders);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        UaeCityAreasLogging.log(
            'API error ${response.statusCode}: ${response.body}');
        throw ApiException(
          response.statusCode,
          'API request failed: ${response.body}',
        );
      }

      UaeCityAreasLogging.log(
          'API GET $endpoint OK (${response.body.length} bytes)');
      return response.body;
    } on ApiException {
      rethrow;
    } on http.ClientException catch (e) {
      UaeCityAreasLogging.log('Network error: ${e.message}');
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      UaeCityAreasLogging.log('Unexpected error: $e');
      throw NetworkException('Unexpected error: $e');
    }
  }
}
