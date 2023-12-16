import 'package:grpc/grpc.dart';
import 'package:nawalt/nawalt.dart';
import 'package:trace/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'track.g.dart';

class NawaltTrackingAPI {
  late final ClientChannel _channel;
  late final TrackingServiceClient _stub;

  NawaltTrackingAPI() {
    _channel = ClientChannel(
      '10.0.2.2',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = TrackingServiceClient(_channel);
  }

  Future<void> recordPosition(UserPositionReport request) async {
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

@Riverpod(keepAlive: true)
NawaltTrackingAPI nawaltTrackingAPI(NawaltTrackingAPIRef ref) {
  return NawaltTrackingAPI();
}

@Riverpod(keepAlive: true)
Future<void> recordPosition(
  RecordPositionRef ref, {
  required UserPositionReport request,
}) async {
  return ref.watch(nawaltTrackingAPIProvider).recordPosition(request);
}
