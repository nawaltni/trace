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
  final int id;
  final String placeName;
  final String contact;
  final String location;
  final String city;
  final String placeCategory;
  final String comment;
  final bool exported = false;
  final DateTime createdAt;

  SurveyRecord({
    this.id = 0,
    required this.placeName,
    required this.contact,
    required this.location,
    required this.city,
    required this.placeCategory,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      // don't set the id, it will be auto-generated
      // 'id': id,
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
    var createdAt = DateTime.tryParse(map['created_at']);
    if (createdAt == null) {
      print('failed to parse date: ${map['created_at']}');
    }
    createdAt ??= DateTime.now();

    var record = SurveyRecord(
      id: map['id'],
      placeName: map['place_name'],
      contact: map['contact'],
      location: map['location'],
      city: map['city'],
      placeCategory: map['place_category'],
      comment: map['comment'],
      createdAt: createdAt,
    );

    return record;
  }
}
