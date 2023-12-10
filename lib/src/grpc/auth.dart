import 'package:grpc/grpc.dart';
import 'package:nawalt/nawalt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

class NawaltAuthAPI {
  late final ClientChannel _channel;
  late final AuthServiceClient _stub;

  NawaltAuthAPI() {
    _channel = ClientChannel(
      '10.0.2.2',
      port: 50053,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _stub = AuthServiceClient(_channel);
  }

  Future<String> pairDevice(String code) async {
    print('NawaltAuthAPI.pairDevice called');
    var pairDeviceRequest = PairDeviceRequest(token: code);
    var pairDeviceResponse = await _stub.pairDevice(pairDeviceRequest);
    print("pairDeviceResponse: ${pairDeviceResponse.token}");
    return pairDeviceResponse.token;
  }

  Future<void> close() async {
    await _channel.shutdown();
  }
}

@Riverpod(keepAlive: true)
NawaltAuthAPI nawaltAuthAPI(NawaltAuthAPIRef ref) {
  return NawaltAuthAPI();
}

@Riverpod(keepAlive: true)
Future<String> pairDevice(
  PairDeviceRef ref, {
  required String token,
}) async {
  return ref.watch(nawaltAuthAPIProvider).pairDevice(token);
}
