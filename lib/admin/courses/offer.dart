
import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Offer {
  static final DatabaseReference courseRef =
      FirebaseDatabase.instance.ref().child('courses');
  final List<Object?> listOfSessions;
  final String price;
  final String name;

  Offer(
      {required this.name, required this.listOfSessions, required this.price});

  final testJson = {
    "test2": {
      "name": "Test course",
      "price": "10sek",
      "sessions": ["intro 1", "intro 2", "intro 3"]
    }
  };

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'session': listOfSessions,
  };

  static Future<List<Offer>> getOffers() async {
    DataSnapshot? _snapshot = await courseRef.get();
    List<Offer> _getOffers = [];

    for (DataSnapshot snap in _snapshot.children) {
      late Map<Object?, dynamic> object = snap.value as Map<Object?, dynamic>;
      final course = Offer.fromJson(object); //error here
      _getOffers.add(course);
    }
    return _getOffers;
  }

  factory Offer.fromJson(Map<Object?, dynamic> json) => _offerFromJson(json);
}

Offer _offerFromJson(Map<Object?, dynamic> json) {
  return Offer(
      name: json['name'],
      price: json['price'],
      listOfSessions: json['session']);
}
