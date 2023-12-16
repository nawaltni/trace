// PhoneMeta represents the phone's metadata
class PhoneMeta {
  final String id;
  final String brand;
  final String model;
  final String os;
  final String appVersion;
  final String carrier;

  PhoneMeta({
    required this.id,
    required this.brand,
    required this.model,
    required this.os,
    required this.appVersion,
    required this.carrier,
  });
}
