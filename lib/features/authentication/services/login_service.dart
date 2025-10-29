import 'package:modn/core/network/api_client.dart';
import 'package:modn/core/network/api_endpoint.dart';
import 'package:modn/core/network/exceptions/network_exceptions.dart';
import 'package:modn/core/network/models/api_response.dart';
import 'package:modn/features/authentication/models/authentication_model.dart';

class LoginService {
  final ApiClient apiClient;

  LoginService({required this.apiClient});

  Future<ApiResponse<AuthenticationModel>> login({
    required String email,
    required String password,
  }) async {
    final apiResponse = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoint.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (apiResponse.isError || apiResponse.data == null) {
      return ApiResponse.withError(
        apiResponse.error ?? const NetworkExceptions.unexpectedError(),
      );
    }

    final authModel = AuthenticationModel.fromJson(apiResponse.data!);

    return ApiResponse.success(
      authModel,
      response: apiResponse.response,
    );
  }

  /// Calls refresh-token endpoint and returns the new access token
  Future<ApiResponse<String>> refreshAccessToken() async {
    final apiResponse =
        await apiClient.post<Map<String, dynamic>>(ApiEndpoint.refreshToken);

    if (apiResponse.isError || apiResponse.data == null) {
      return ApiResponse.withError(
        apiResponse.error ?? const NetworkExceptions.unexpectedError(),
      );
    }

    final token = apiResponse.data!['token']?.toString();
    if (token == null || token.isEmpty) {
      return ApiResponse.withError(
        const NetworkExceptions.defaultError('Invalid refresh response'),
      );
    }

    return ApiResponse.success(
      token,
      response: apiResponse.response,
    );
  }
}
