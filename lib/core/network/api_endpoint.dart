/// API endpoints for the application
class ApiEndpoint {
  /// Base URL for the API
  static const String baseUrl = 'https://modn-api.semicolonsa.dev/api/';

  /// API version
  // static const String apiVersion = 'v1';

  /// Timeout in milliseconds
  static const int timeout = 30000;

  /// Endpoints
  static const String login = 'admin-dashboard/auth/login';
  static const String refreshToken = 'admin-dashboard/auth/refresh-token';
  static const String activeEvent = 'event/active';
  static const String scanQr = 'entry-log/scan';

  /// Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get a full endpoint URL
  static String getEndpoint(String endpoint) {
    return '$baseUrl/$endpoint';
  }
}
