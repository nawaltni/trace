import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:trace/src/features/current_meta/data/current_meta.dart';
import 'package:trace/src/grpc/auth.dart';
import 'package:trace/src/grpc/track.dart';

Future<void> initializeService() async {
  final backgroundService = FlutterBackgroundService();
  await backgroundService.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: false, autoStart: false));
}

void onStart(ServiceInstance service) async {
  await Firebase.initializeApp();

  final nawaltTrackingAPI = NawaltTrackingAPI();
  final currentMetaService = CurrentMetaService(nawaltTrackingAPI);

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

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final currentMeta = await currentMetaService.currentMeta();

    print("Current Meta: ${currentMeta.location}, ${currentMeta.battery}, ${currentMeta.deviceInfo}");
    print("Sending metadata with token: $token");
    // we send metrics to our endpoint here
  });

  service.on('stopService').listen((event) {
    timer.cancel();
    service.stopSelf();
    print("Stopping service");
  });
}

