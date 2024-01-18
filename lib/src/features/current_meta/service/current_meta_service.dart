import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trace/domain/phone_meta.dart';
import 'package:trace/domain/user_position.dart';
import 'package:trace/src/features/authentication/data/auth_repository.dart';
import 'package:trace/src/features/current_meta/data/current_meta.dart';
import 'package:trace/src/grpc/track.dart';
import 'package:uuid/uuid.dart';

part 'current_meta_service.g.dart';

class CurrentMetaService {
  final uuid = const Uuid();
  final CurrentMetaRepository _metaRepository;
  final AuthRepository _authRepository;

  final NawaltTrackingClientGRPC _nawaltTrackingClientGRPC =
      NawaltTrackingClientGRPC();

  CurrentMetaService(this._metaRepository, this._authRepository);

  Future<AppMetadata> getCurrentMeta() async {
    return _metaRepository.currentMeta();
  }

  Future<void> recordPosition() async {
    final meta = await getCurrentMeta();
    final authData = await _authRepository.getAuthData();

    try {
      final id = uuid.v7();

      final phoneMeta = PhoneMeta(
        id: meta.phoneMeta.id,
        brand: meta.phoneMeta.brand,
        model: meta.phoneMeta.model,
        os: meta.phoneMeta.os,
        appVersion: meta.phoneMeta.appVersion,
        carrier: meta.phoneMeta.carrier,
      );

      final userPosition = UserPositionReport(
          uuid: id.toString(),
          userID: authData.userId,
          latitude: meta.location.latitude,
          longitude: meta.location.longitude,
          timestamp: DateTime.now(),
          battery: meta.battery,
          phoneMeta: phoneMeta);

      final auth = await _authRepository.getAuthData();

      await _nawaltTrackingClientGRPC.recordPosition(auth, userPosition);
    } catch (e) {
      print('record position failed with error: $e');
      return;
    }
  }
}

@riverpod
CurrentMetaService currentMetaService(CurrentMetaServiceRef ref) {
  return CurrentMetaService(ref.watch(currentMetaRepositoryProvider),
      ref.watch(authRepositoryProvider));
}
