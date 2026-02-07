import 'package:http/http.dart' as http;
import '../errors/cities_areas_exceptions.dart';

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
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestHeaders = <String, String>{};

      // Add custom headers if provided
      if (headers != null) {
        requestHeaders.addAll(headers!);
      }

      final response = await http.get(uri, headers: requestHeaders);

      // Check for error status codes
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          response.statusCode,
          'API request failed: ${response.body}',
        );
      }

      return response.body;
    } on ApiException {
      rethrow;
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }
}
