import 'package:modn/core/network/api_client.dart';
import 'package:modn/core/network/api_endpoint.dart';
import 'package:modn/core/network/exceptions/network_exceptions.dart';
import 'package:modn/core/network/models/api_response.dart';
import 'package:modn/features/events/models/active_event_model.dart';

class EventService {
  const EventService({required this.apiClient});

  final ApiClient apiClient;

  Future<ApiResponse<EventDetails?>> getActiveEvent() async {
    final apiResponse = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoint.activeEvent,
    );

    if (apiResponse.isError || apiResponse.data == null) {
      return ApiResponse.withError(
        apiResponse.error ?? const NetworkExceptions.unexpectedError(),
      );
    }

    final parsed = ActiveEventResponse.fromJson(apiResponse.data!);

    return ApiResponse.success(
      parsed.result,
      response: apiResponse.response,
    );
  }
}
