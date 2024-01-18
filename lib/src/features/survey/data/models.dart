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
  final DateTime createdAt = DateTime.now();
  final bool exported = false;

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
      'place_name': placeName,
      'contact': contact,
      'location': location,
      'city': city,
      'place_category': placeCategory,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'exported': exported ? 1 : 0,
    };
  }

  factory SurveyRecord.fromMap(Map<String, dynamic> map) {
    return SurveyRecord(
      placeName: map['place_name'],
      contact: map['contact'],
      location: map['location'],
      city: map['city'],
      placeCategory: map['place_category'],
      comment: map['comment'],
    );
  }
}
