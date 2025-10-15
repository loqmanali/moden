import 'package:dio/dio.dart';
import 'package:modn/core/network/api_client.dart';
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
    try {
      // call API
      final apiResponse = await apiClient.post<Map<String, dynamic>>(
        '/login',
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

      // تحويل الداتا إلى موديل الـ AuthenticationModel
      final authModel = AuthenticationModel.fromJson(apiResponse.data!);

      // في حالة النجاح
      return ApiResponse.success(
        authModel,
        response: apiResponse.response,
      );
    } on DioException catch (dioError) {
      // التعامل مع أخطاء Dio (مثل timeout أو 401)
      return ApiResponse.withError(
        NetworkExceptions.defaultError(dioError.message ?? dioError.toString()),
      );
    } catch (e) {
      // التعامل مع أي خطأ آخر
      return ApiResponse.withError(
        NetworkExceptions.defaultError(e.toString()),
      );
    }
  }
}
