import 'package:trace/domain/phone_meta.dart';

// Represents the user's current position according to
// the geolocation service
class UserPosition {
  final String userID;
  final double latitude;
  final double longitude;
  final double clientID;
  final String placeID;
  final String claceName;
  final DateTime checkIn;
  final DateTime checkOut;

  UserPosition({
    required this.userID,
    required this.latitude,
    required this.longitude,
    required this.clientID,
    required this.placeID,
    required this.claceName,
    required this.checkIn,
    required this.checkOut,
  });
}

// Represents a user's position report to send to the server
class UserPositionReport {
  final String uuid;
  final String userID;
  final double latitude;
  final double longitude;
  final double clientID;
  final DateTime timestamp;

  final PhoneMeta phoneMeta;

  UserPositionReport({
    required this.uuid,
    required this.userID,
    required this.latitude,
    required this.longitude,
    required this.clientID,
    required this.timestamp,
    required this.phoneMeta,
  });
}
