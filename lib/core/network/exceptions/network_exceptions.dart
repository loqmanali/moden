import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

/// Custom exception class to handle various network-related errors
@freezed
class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest({String? message}) =
      UnauthorizedRequest;

  const factory NetworkExceptions.badRequest({String? message}) = BadRequest;

  const factory NetworkExceptions.forbidden() = Forbidden;

  const factory NetworkExceptions.forbiddenRequest({String? message}) =
      ForbiddenRequest;

  const factory NetworkExceptions.notFound({String? message}) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout({String? message}) =
      RequestTimeout;

  const factory NetworkExceptions.receiveTimeout() = ReceiveTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict({String? message}) = Conflict;

  const factory NetworkExceptions.internalServerError({String? message}) =
      InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable({String? message}) =
      ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  const factory NetworkExceptions.badCertificate() = BadCertificate;

  /// Returns a message associated with the exception type
  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = '';

    networkExceptions.when(
      requestCancelled: () {
        errorMessage = 'Request was cancelled';
      },
      unauthorizedRequest: (String? message) {
        errorMessage = message ?? 'Unauthorized request';
      },
      badRequest: (String? message) {
        errorMessage = message ?? 'Bad request';
      },
      forbidden: () {
        errorMessage = 'Forbidden';
      },
      forbiddenRequest: (String? message) {
        errorMessage = message ?? 'Forbidden request';
      },
      notFound: (String? message) {
        errorMessage =
            message ?? 'The requested resource could not be found';
      },
      methodNotAllowed: () {
        errorMessage = 'Method not allowed';
      },
      notAcceptable: () {
        errorMessage = 'The request is not acceptable';
      },
      requestTimeout: (String? message) {
        errorMessage = message ?? 'Request timeout';
      },
      receiveTimeout: () {
        errorMessage = 'Receive timeout';
      },
      sendTimeout: () {
        errorMessage = 'Send timeout';
      },
      conflict: (String? message) {
        errorMessage = message ?? 'Resource conflict';
      },
      internalServerError: (String? message) {
        errorMessage = message ?? 'Internal server error';
      },
      notImplemented: () {
        errorMessage = 'Not implemented';
      },
      serviceUnavailable: (String? message) {
        errorMessage = message ?? 'Service unavailable';
      },
      noInternetConnection: () {
        errorMessage = 'No internet connection';
      },
      formatException: () {
        errorMessage = 'Format exception';
      },
      unableToProcess: () {
        errorMessage = 'Unable to process the data';
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      unexpectedError: () {
        errorMessage = 'An unexpected error occurred';
      },
      badCertificate: () {
        errorMessage = 'Bad certificate';
      },
    );

    return errorMessage;
  }
}
