import 'package:modn/core/network/api_client.dart';
import 'package:modn/core/network/api_endpoint.dart';
import 'package:modn/core/network/exceptions/network_exceptions.dart';
import 'package:modn/core/network/models/api_response.dart';
import 'package:modn/features/qr/models/qr_scan_model.dart';

class QrScanService {
  const QrScanService({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<QrScanResponse>> scanQrCode({
    required QrScanRequest request,
  }) async {
    final apiResponse = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoint.scanQr,
      data: request.toJson(),
    );

    if (apiResponse.isError || apiResponse.data == null) {
      return ApiResponse.withError(
        apiResponse.error ?? const NetworkExceptions.unexpectedError(),
      );
    }

    try {
      final response = QrScanResponse.fromJson(apiResponse.data!);
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
