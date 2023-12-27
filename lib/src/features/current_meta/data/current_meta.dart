import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:trace/domain/phone_meta.dart';

part 'current_meta.g.dart';

class AppMetadata {
  final Position location;
  final String battery;
  final PhoneMeta phoneMeta;

  AppMetadata({
    required this.location,
    required this.battery,
    required this.phoneMeta,
  });
}

// Contains methods to get the current meta data and position stream
// of the device
class CurrentMetaRepository {
  CurrentMetaRepository();

  static LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, distanceFilter: 10);

  final battery = Battery();

  /// Returns the current meta data of the device
  Future<AppMetadata> currentMeta() async {
    final location = await currentLocation();
    final battery = await batteryLevel();
    final meta = await phoneMeta();

    return AppMetadata(
      location: location,
      battery: battery,
      phoneMeta: meta,
    );
  }

// get current location
  Future<Position> currentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied forever, handle appropriately.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<String> batteryLevel() async {
    final batteryLevel = await battery.batteryLevel;
    return batteryLevel.toString();
  }

  Future<PhoneMeta> phoneMeta() async {
    PhoneMeta info = PhoneMeta(
      id: 'Unknown',
      brand: 'Unknown',
      model: 'Unknown',
      os: 'Unknown',
      appVersion: 'Unknown',
      carrier: 'Unknown',
    );

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        info = _readAndroidInfo(await DeviceInfoPlugin().androidInfo);
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        info = _readIosInfo(await DeviceInfoPlugin().iosInfo);
      }
    } on PlatformException {
      info = PhoneMeta(
        id: 'Unknown',
        brand: 'Unknown',
        model: 'Unknown',
        os: 'Unknown',
        appVersion: 'Unknown',
        carrier: 'Unknown',
      );
    }

    return Future.value(info);
  }

// get position stream

  static Stream<Position> positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings);
}

PhoneMeta _readAndroidInfo(AndroidDeviceInfo info) {
  return PhoneMeta(
    id: info.id,
    brand: info.brand,
    model: info.model,
    os: info.version.release,
    appVersion: "Unknown",
    carrier: "Unknown",
  );
}

PhoneMeta _readIosInfo(IosDeviceInfo info) {
  return PhoneMeta(
    id: info.identifierForVendor.toString(),
    brand: 'Apple',
    model: info.model,
    os: info.systemVersion,
    appVersion: "Unknown",
    carrier: "Unknown",
  );
}

@riverpod
CurrentMetaRepository currentMetaRepository(CurrentMetaRepositoryRef ref) {
  return CurrentMetaRepository();
}

@riverpod
Future<AppMetadata> currentMeta(CurrentMetaRef ref) async {
  return ref.watch(currentMetaRepositoryProvider).currentMeta();
}

@riverpod
Future<Position> currentLocation(CurrentLocationRef ref) async {
  return ref.watch(currentMetaRepositoryProvider).currentLocation();
}

@riverpod
Future<String> batteryLevel(BatteryLevelRef ref) async {
  return ref.watch(currentMetaRepositoryProvider).batteryLevel();
}

@riverpod
Future<PhoneMeta> phoneMeta(PhoneMetaRef ref) async {
  return ref.watch(currentMetaRepositoryProvider).phoneMeta();
}
