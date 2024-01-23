import 'package:geolocator/geolocator.dart';

class PlaceDraft {
  final String userId;
  final String name;
  final String location;
  final String description;
  final String contact;
  final String contactRole;
  final String city;
  final String region;
  final String country;
  final String address;
  final String postalCode;
  final String category;
  final DateTime timestamp;

  PlaceDraft({
    required this.userId,
    required this.name,
    required this.location,
    required this.description,
    required this.contact,
    required this.contactRole,
    required this.city,
    required this.region,
    required this.country,
    required this.address,
    required this.postalCode,
    required this.category,
    required this.timestamp,
  });
}
