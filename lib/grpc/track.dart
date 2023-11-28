import 'package:grpc/grpc.dart';
import 'package:nawalt/nawalt.dart';
import 'package:trace/domain/domain.dart' as domain;

class NawaltTrackingAPI {
  late final ClientChannel _channel;
  late final TrackingServiceClient _stub;

  NawaltTrackingAPI() {
    _channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = TrackingServiceClient(_channel);
  }

  Future<void> recordPosition(domain.UserPositionReport request) async {
    var recordPositionRequest = RecordPositionRequest(
      // Map UserPositionReport fields to RecordPositionRequest fields
      userId: request.userID,
      location: GeoPoint(
        latitude: request.latitude,
        longitude: request.longitude,
      ),

      timestamp: Timestamp.fromDateTime(request.timestamp),
    );

    await _stub.recordPosition(recordPositionRequest);
  }

  Future<void> close() async {
    await _channel.shutdown();
  }
}
