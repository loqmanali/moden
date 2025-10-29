import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging requests, responses, and errors
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final method = options.method.toUpperCase();
      final url = options.uri.toString();

      log('\n--> $method $url', name: 'LoggingInterceptor');

      if (options.headers.isNotEmpty) {
        log('Headers:', name: 'LoggingInterceptor');
        options.headers.forEach(
            (key, value) => log('$key: $value', name: 'LoggingInterceptor'));
      }

      if (options.data != null) {
        log('Request Body:', name: 'LoggingInterceptor');
        _prettyPrintJson(options.data);
      }

      if (options.queryParameters.isNotEmpty) {
        log('Query Parameters:', name: 'LoggingInterceptor');
        options.queryParameters.forEach(
            (key, value) => log('$key: $value', name: 'LoggingInterceptor'));
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = response.statusCode;
      final method = response.requestOptions.method.toUpperCase();
      final url = response.requestOptions.uri.toString();

      log('\n<-- $statusCode $method $url', name: 'LoggingInterceptor');

      if (response.headers.map.isNotEmpty) {
        log('Headers:', name: 'LoggingInterceptor');
        response.headers
            .forEach((name, values) => log('$name: ${values.join(',')}'));
      }

      log('Response Body:', name: 'LoggingInterceptor');
      _prettyPrintJson(response.data);
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = err.response?.statusCode;
      final method = err.requestOptions.method.toUpperCase();
      final url = err.requestOptions.uri.toString();

      log('\n<-- Error $statusCode $method $url', name: 'LoggingInterceptor');
      log('Error: ${err.error}', name: 'LoggingInterceptor');

      if (err.response != null) {
        log('Response Body:', name: 'LoggingInterceptor');
        _prettyPrintJson(err.response!.data);
      }
    }

    super.onError(err, handler);
  }

  /// Helper method to pretty print JSON data
  void _prettyPrintJson(dynamic data) {
    if (data == null) {
      log('null', name: 'LoggingInterceptor');
      return;
    }

    if (data is Map || data is List) {
      try {
        // Try to use json.encode for nice formatting
        // but this might not work for all data types
        log(data.toString(), name: 'LoggingInterceptor');
      } catch (e) {
        log(data.toString(), name: 'LoggingInterceptor');
      }
    } else {
      log(data.toString(), name: 'LoggingInterceptor');
    }
  }
}
