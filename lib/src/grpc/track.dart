import 'package:grpc/grpc.dart';
import 'package:nawalt/nawalt.dart';
import 'package:trace/domain/auth.dart';
import 'package:trace/domain/domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'track.g.dart';

class NawaltTrackingClientGRPC {
  late final ClientChannel _channel;
  late final TrackingServiceClient _stub;

  NawaltTrackingClientGRPC() {
    _channel = ClientChannel(
      '10.0.2.2',
      port: 50051,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _stub = TrackingServiceClient(_channel);
  }

  Future<void> recordPosition(AuthData auth, UserPositionReport request) async {
    var recordPositionRequest = RecordPositionRequest(
      // Map UserPositionReport fields to RecordPositionRequest fields
      userId: request.userID,
      location: GeoPoint(
        latitude: request.latitude,
        longitude: request.longitude,
      ),
      clientId: "",
      metadata: PhoneMetadata(
        deviceId: request.phoneMeta.id,
        brand: request.phoneMeta.brand,
        model: request.phoneMeta.model,
        os: request.phoneMeta.os,
        appVersion: request.phoneMeta.appVersion,
        carrier: request.phoneMeta.carrier,
        battery: 30,
      ),

      timestamp: Timestamp.fromDateTime(request.timestamp),
    );

    final metadata = {'Authorization': ""};
    if (auth.token != '') {
      metadata['Authorization'] = "Bearer ${auth.token}";
    }

    await _stub.recordPosition(recordPositionRequest,
        options: CallOptions(metadata: metadata));
  }

  Future<void> close() async {
    await _channel.shutdown();
  }
}

@Riverpod(keepAlive: true)
NawaltTrackingClientGRPC nawaltTrackingAPI(NawaltTrackingAPIRef ref) {
  return NawaltTrackingClientGRPC();
}

@Riverpod(keepAlive: true)
Future<void> recordPosition(
  RecordPositionRef ref, {
  required AuthData auth,
  required UserPositionReport request,
}) async {
  return ref.watch(nawaltTrackingAPIProvider).recordPosition(auth, request);
}
