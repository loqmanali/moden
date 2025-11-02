import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_endpoint.dart';
import 'exceptions/network_exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/pretty_dio_logger.dart';
import 'models/api_response.dart';

/// API client for handling network requests
class ApiClient {
  late final Dio _dio;
  final int timeout;
  final bool useAuth;

  /// API client constructor
  ApiClient({
    this.timeout = 30000,
    this.useAuth = true,
  }) {
    _initDio();
  }

  /// Initialize Dio client with base options and interceptors
  void _initDio() {
    final options = BaseOptions(
      baseUrl: ApiEndpoint.baseUrl,
      connectTimeout: Duration(milliseconds: timeout),
      receiveTimeout: Duration(milliseconds: timeout),
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.addAll([
      // CustomLoggingInterceptor(),
      if (kDebugMode)
        PrettyDioLogger.builder((builder) => builder
          ..setRequestHeader(true)
          ..setRequest(true)
          ..setResponseHeader(true)
          ..setEnableColors(true)
          ..setLogPrint((obj) {
            // Write to file instead of console
            debugPrint(obj.toString());
          })),
      // LogInterceptor(),
    ]);

    if (useAuth) {
      _dio.interceptors.add(AuthInterceptor());
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) async {
    final requestOptions = _resolveOptions(options, requiresAuth);
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      // Validate that response is JSON, not HTML
      if (_isHtmlResponse(response)) {
        return ApiResponse<T>.withError(
          const NetworkExceptions.defaultError(
            'Server returned HTML instead of JSON. The API endpoint may be incorrect or the server is not running properly.',
          ),
        );
      }

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) async {
    final requestOptions = _resolveOptions(options, requiresAuth);
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Validate that response is JSON, not HTML
      if (_isHtmlResponse(response)) {
        return ApiResponse<T>.withError(
          const NetworkExceptions.defaultError(
            'Server returned HTML instead of JSON. The API endpoint may be incorrect or the server is not running properly.',
          ),
        );
      }

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) async {
    final requestOptions = _resolveOptions(options, requiresAuth);
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Validate that response is JSON, not HTML
      if (_isHtmlResponse(response)) {
        return ApiResponse<T>.withError(
          const NetworkExceptions.defaultError(
            'Server returned HTML instead of JSON. The API endpoint may be incorrect or the server is not running properly.',
          ),
        );
      }

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    final requestOptions = _resolveOptions(options, requiresAuth);
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      // Validate that response is JSON, not HTML
      if (_isHtmlResponse(response)) {
        return ApiResponse<T>.withError(
          const NetworkExceptions.defaultError(
            'Server returned HTML instead of JSON. The API endpoint may be incorrect or the server is not running properly.',
          ),
        );
      }

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool requiresAuth = true,
  }) async {
    final requestOptions = _resolveOptions(options, requiresAuth);
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Validate that response is JSON, not HTML
      if (_isHtmlResponse(response)) {
        return ApiResponse<T>.withError(
          const NetworkExceptions.defaultError(
            'Server returned HTML instead of JSON. The API endpoint may be incorrect or the server is not running properly.',
          ),
        );
      }

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// Download file
  Future<ApiResponse<String>> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    Options? options,
    bool requiresAuth = true,
  }) async {
    final requestOptions = _resolveOptions(options, requiresAuth);
    try {
      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        options: requestOptions,
      );

      return ApiResponse<String>.fromResponse(response, data: savePath);
    } catch (e) {
      return ApiResponse<String>.withError(_handleError(e));
    }
  }

  /// Check if response is HTML instead of JSON
  bool _isHtmlResponse(Response response) {
    // Check if response data is a string starting with HTML tags
    if (response.data is String) {
      final data = (response.data as String).trim();
      return data.startsWith('<!DOCTYPE') ||
          data.startsWith('<html') ||
          data.startsWith('<HTML');
    }
    return false;
  }

  /// Handle all possible errors from Dio
  NetworkExceptions _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return const NetworkExceptions.requestTimeout();
        case DioExceptionType.sendTimeout:
          return const NetworkExceptions.sendTimeout();
        case DioExceptionType.receiveTimeout:
          return const NetworkExceptions.receiveTimeout();
        case DioExceptionType.cancel:
          return const NetworkExceptions.requestCancelled();
        case DioExceptionType.badResponse:
          return _handleBadResponse(error);
        case DioExceptionType.connectionError:
          return const NetworkExceptions.noInternetConnection();
        case DioExceptionType.badCertificate:
          return const NetworkExceptions.badCertificate();
        default:
          return const NetworkExceptions.unexpectedError();
      }
    } else if (error is SocketException) {
      return const NetworkExceptions.noInternetConnection();
    } else {
      return const NetworkExceptions.unexpectedError();
    }
  }

  /// Handle bad responses with different status codes
  NetworkExceptions _handleBadResponse(DioException error) {
    if (error.response == null) {
      debugPrint('🔴 DioException with null response: ${error.message}');
      debugPrint('🔴 Error type: ${error.type}');
      debugPrint('🔴 Request: ${error.requestOptions.uri}');
      return const NetworkExceptions.unexpectedError();
    }

    debugPrint('🔴 Status Code: ${error.response!.statusCode}');
    debugPrint('🔴 Response Data: ${error.response!.data}');
    debugPrint('🔴 Response Headers: ${error.response!.headers}');

    // Extract error message from backend response
    final rawBackendMessage = _extractBackendErrorMessage(error.response!);
    final effectiveMessage =
        (rawBackendMessage != null && rawBackendMessage.trim().isNotEmpty)
            ? rawBackendMessage.trim()
            : null;

    switch (error.response!.statusCode) {
      case 400:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.badRequest();
      case 401:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.unauthorizedRequest();
      case 403:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.forbiddenRequest();
      case 404:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.notFound();
      case 409:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.conflict();
      case 408:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.requestTimeout();
      case 500:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.internalServerError();
      case 503:
        return effectiveMessage != null
            ? NetworkExceptions.defaultError(effectiveMessage)
            : const NetworkExceptions.serviceUnavailable();
      default:
        return NetworkExceptions.defaultError(
          effectiveMessage ??
              'Error with status code: ${error.response!.statusCode}',
        );
    }
  }

  /// Extract error message from backend response
  /// Backend typically returns: { "error": "code", "message": "description" }
  String? _extractBackendErrorMessage(Response response) {
    try {
      final data = response.data;

      if (data is Map<String, dynamic>) {
        // Try to get message field first
        if (data.containsKey('message') && data['message'] != null) {
          return data['message'].toString();
        }

        // Try to get error field
        if (data.containsKey('error') && data['error'] != null) {
          final error = data['error'];
          if (error is String) {
            return error;
          } else if (error is Map && error.containsKey('message')) {
            return error['message'].toString();
          }
        }

        // Try to get errors array (validation errors)
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.first.toString();
          }
        }
      } else if (data is String) {
        return data;
      }
    } catch (e) {
      // If extraction fails, return null to use default message
    }

    return null;
  }

  /// Get raw Dio client (use with caution)
  Dio get dio => _dio;

  Options? _resolveOptions(Options? options, bool requiresAuth) {
    if (options == null && requiresAuth) {
      return null;
    }

    if (options == null && !requiresAuth) {
      return Options(extra: {'requiresAuth': false});
    }

    final updatedOptions = options!;
    final updatedExtra = <String, dynamic>{...?updatedOptions.extra};
    updatedExtra['requiresAuth'] = requiresAuth;
    updatedOptions.extra = updatedExtra;

    if (!requiresAuth) {
      final headers = <String, dynamic>{...?updatedOptions.headers};
      headers.remove('Authorization');
      updatedOptions.headers = headers;
    }

    return updatedOptions;
  }
}
