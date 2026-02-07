/// Base exception for cities and areas plugin
class CitiesAreasException implements Exception {
  /// Error message
  final String message;

  /// Creates a CitiesAreasException
  const CitiesAreasException(this.message);

  @override
  String toString() => 'CitiesAreasException: $message';
}

/// Exception thrown when a network error occurs
class NetworkException extends CitiesAreasException {
  /// Creates a NetworkException
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when API returns an error status code
class ApiException extends CitiesAreasException {
  /// HTTP status code
  final int statusCode;

  /// Creates an ApiException
  const ApiException(this.statusCode, super.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Exception thrown when JSON parsing fails
class ParseException extends CitiesAreasException {
  /// Creates a ParseException
  const ParseException(super.message);

  @override
  String toString() => 'ParseException: $message';
}

/// Exception thrown when cache operation fails
class CacheException extends CitiesAreasException {
  /// Creates a CacheException
  const CacheException(super.message);

  @override
  String toString() => 'CacheException: $message';
}
