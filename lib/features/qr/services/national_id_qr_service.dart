import 'package:modn/core/network/api_client.dart';
import 'package:modn/core/network/api_endpoint.dart';
import 'package:modn/core/network/exceptions/network_exceptions.dart';
import 'package:modn/core/network/models/api_response.dart';
import 'package:modn/features/qr/models/national_id_qr_model.dart';

class NationalIdQrService {
  const NationalIdQrService({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<NationalIdQrResponse>> getUserQrCode({
    required NationalIdQrRequest request,
  }) async {
    // Using POST instead of GET because web platform doesn't support GET with body
    final apiResponse = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoint.getUserQr,
      queryParameters: request.toJson(),
    );

    if (apiResponse.isError || apiResponse.data == null) {
      return ApiResponse.withError(
        apiResponse.error ?? const NetworkExceptions.unexpectedError(),
      );
    }

    try {
      final response = NationalIdQrResponse.fromJson(apiResponse.data!);
      return ApiResponse.success(
        response,
        response: apiResponse.response,
      );
    } catch (e) {
      return ApiResponse.withError(
        NetworkExceptions.defaultError('Failed to parse response: $e'),
      );
    }
  }
}
