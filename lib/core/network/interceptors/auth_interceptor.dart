import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:modn/core/storage/storage_service.dart';

/// Interceptor to add authentication headers to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requiresAuth = options.extra['requiresAuth'] != false;
    if (!requiresAuth) {
      super.onRequest(options, handler);
      return;
    }

    final token = await _getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['token'] = 'Bearer $token';
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('✅ AuthInterceptor: Headers added to request');
    } else {
      debugPrint('❌ AuthInterceptor: No token available');
    }

    super.onRequest(options, handler);
  }

  /// Get the authentication token
  Future<String?> _getToken() async {
    return Storage.getToken();
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle the response
    // For example, check if the token needs to be refreshed
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle authentication errors
    if (err.response?.statusCode == 401) {
      // TODO: Handle token expiration and refresh
      // For example:
      // _refreshToken().then((_) {
      //   // Retry the request with the new token
      //   _retryRequest(err.requestOptions, handler);
      // }).catchError((_) {
      //   // Token refresh failed, handle logout
      //   _handleLogout();
      //   handler.next(err);
      // });
      final alreadyRetried = err.requestOptions.extra['__retried'] == true;

      if (!alreadyRetried) {
        err.requestOptions.extra['__retried'] = true;
        _retryRequest(err.requestOptions, handler);
        return;
      }
    } else {
      handler.next(err);
      return;
    }

    handler.next(err);
  }

  /// Retry a request with updated options
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final requiresAuth = requestOptions.extra['requiresAuth'] != false;

    // Update the token in the request headers
    final token = requiresAuth ? await _getToken() : null;

    if (token != null && token.isNotEmpty) {
      requestOptions.headers['token'] = 'Bearer $token';
      requestOptions.headers['Authorization'] = 'Bearer $token';
    } else if (!requiresAuth) {
      requestOptions.headers.remove('token');
      requestOptions.headers.remove('Authorization');
    }

    try {
      // Use the same Dio instance to retry the request
      // This preserves the base URL and other configurations
      final dio = Dio(BaseOptions(
        baseUrl: requestOptions.baseUrl,
        connectTimeout: requestOptions.connectTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        headers: requestOptions.headers,
      ));

      final response = await dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          extra: requestOptions.extra,
        ),
      );

      handler.resolve(response);
    } catch (e) {
      handler.next(DioException(
        requestOptions: requestOptions,
        error: e.toString(),
      ));
    }
  }
}
