import 'dart:developer';

import 'package:dio/dio.dart';

/// {@template network_logging_interceptor}
/// A network logging interceptor for Dio that provides detailed, color-coded logging
/// of network requests, responses, and errors to help developers track and debug
/// network interactions efficiently.
/// {@endtemplate}
class CustomLoggingInterceptor extends Interceptor {
  // ANSI color codes for console output
  static const _colors = {
    'red': '\x1B[31m',
    'green': '\x1B[32m',
    'yellow': '\x1B[33m',
    'blue': '\x1B[34m',
    'reset': '\x1B[0m',
  };

  final bool _isDebug;

  /// {@template logging_interceptor_constructor}
  /// Creates a [LoggingInterceptor] with optional debug configuration.
  ///
  /// **Parameters:**
  /// - `isDebug`: If set to `true`, logging is enabled.
  ///
  /// **Usage:**
  /// ```dart
  /// final interceptor = LoggingInterceptor(isDebug: true);
  /// dio.interceptors.add(interceptor);
  /// ```
  /// {@endtemplate}
  CustomLoggingInterceptor({bool isDebug = true}) : _isDebug = isDebug;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isDebug) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_isDebug) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isDebug) {
      _logError(err);
    }
    handler.next(err);
  }

  /// Logs the details of the request
  void _logRequest(RequestOptions options) {
    _logSection(
      color: _colors['blue']!,
      title: 'Request',
      details: [
        '${options.method} ${options.uri}',
        'Headers: ${options.headers}',
        if (options.data != null) 'Body: ${options.data}',
      ],
    );
  }

  /// Logs the details of the response
  void _logResponse(Response response) {
    final color = _determineResponseColor(response.statusCode);
    _logSection(
      color: color,
      title: 'Response',
      details: [
        '${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
        // 'Data: ${response.data}',
      ],
    );
  }

  /// Logs the details of the error
  void _logError(DioException err) {
    _logSection(
      color: _colors['red']!,
      title: 'Error',
      details: [
        '${err.type}: ${err.message}',
        '${err.response?.statusCode} ${err.requestOptions.method} ${err.requestOptions.uri}',
        if (err.response?.data != null) 'Response: ${err.response?.data}',
      ],
    );
  }

  /// Determines the color for logging based on the HTTP response status code
  String _determineResponseColor(int? statusCode) {
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      return _colors['green']!;
    }
    return _colors['yellow']!;
  }

  /// Generic logging method to reduce code duplication for request, response, and error sections
  void _logSection({
    required String color,
    required String title,
    required List<String> details,
  }) {
    log(
      '$color┌── $title ──────────────────────────────────────────────────────────${_colors['reset']}',
    );
    for (final detail in details) {
      log('$color│ $detail${_colors['reset']}');
    }
    log(
      '$color└─────────────────────────────────────────────────────────────────────${_colors['reset']}',
    );
  }
}
