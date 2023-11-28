// PhoneMeta represents the phone's metadata
class PhoneMeta {
  final String deviceID;
  final String model;
  final String osVersion;
  final String carrier;
  final String corporateID;

  PhoneMeta({
    required this.deviceID,
    required this.model,
    required this.osVersion,
    required this.carrier,
    required this.corporateID,
  });
}
