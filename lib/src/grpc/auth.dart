import 'package:grpc/grpc.dart';
import 'package:nawalt/nawalt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trace/domain/profile.dart';

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

  Future<UserProfile> getProfile(String? token) async {
    final metadata = {'Authorization': ""};
    if (token != null) {
      metadata['Authorization'] = "Bearer $token";
    }

    print('NawaltAuthAPI.getProfile called');
    final getProfileRequest = GetProfileRequest();
    final profile = await _stub.getProfile(getProfileRequest,
        options: CallOptions(metadata: metadata));
    print("getProfileResponse: $profile");

    final up = UserProfile(
        id: profile.userId,
        email: profile.email,
        name: profile.name,
        phone: profile.phone,
        address: profile.address,
        city: profile.city,
        state: profile.state);

    return up;
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
