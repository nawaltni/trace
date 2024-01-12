class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'],
      name: map['name'],
    );
  }
}

class SurveyRecord {
  final String placeName;
  final String contact;
  final String location;
  final String city;
  final String placeCategory;
  final String comment;

  SurveyRecord({
    required this.placeName,
    required this.contact,
    required this.location,
    required this.city,
    required this.placeCategory,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'contact': contact,
      'location': location,
      'city': city,
      'placeCategory': placeCategory,
      'comment': comment,
    };
  }
}
