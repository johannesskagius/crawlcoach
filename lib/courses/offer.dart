
import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Offer {
  static final DatabaseReference courseRef =
      FirebaseDatabase.instance.ref().child('courses');
  final Map<Object?, Object?> listOfSessions;
  final String price;
  final String name;
  final String desc;
  final String userID;

  Offer(
      {required this.name,
      required this.listOfSessions,
      required this.price,
      required this.desc,
      required this.userID});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': desc,
        'price': price,
        'session': listOfSessions,
        'userID': userID
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

  factory Offer.fromJson(dynamic json) => _offerFromJson(json);
}

Offer _offerFromJson(dynamic json) {
  return Offer(
      name: json['name'],
      price: json['price'],
      listOfSessions: json['session'],
      desc: json['description'],
      userID: json['userID']);
}
