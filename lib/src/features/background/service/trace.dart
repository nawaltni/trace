import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trace/src/features/authentication/data/auth_repository.dart';
import 'package:trace/src/features/current_meta/data/current_meta.dart';
import 'package:trace/src/features/current_meta/service/current_meta_service.dart';
import 'package:trace/src/grpc/auth.dart';
import 'package:trace/src/grpc/track.dart';
import 'package:uuid/uuid.dart';

Future<void> initializeService() async {
  final backgroundService = FlutterBackgroundService();
  await backgroundService.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: false, autoStart: false));
}

void onStart(ServiceInstance service) async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  final nawaltTrackingAPI = NawaltTrackingClientGRPC();
  final currentMetaRepository = CurrentMetaRepository();
  final NawaltAuthAPI nawaltAuthAPI = NawaltAuthAPI();
  final authRepo = AuthRepository(FirebaseAuth.instance, nawaltAuthAPI);
  final currentMetaService =
      CurrentMetaService(currentMetaRepository, authRepo);

  // make sure we have all the dependencies we need within this function
  // otherwise we will get a runtime error
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      print(user.uid);
    }
  });
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  String generateUuidV7() {
    const uuid = Uuid();
    return uuid.v7();
  }

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    currentMetaService.recordPosition();
  });

  service.on('stopService').listen((event) {
    timer.cancel();
    service.stopSelf();
    print("Stopping service");
  });
}
