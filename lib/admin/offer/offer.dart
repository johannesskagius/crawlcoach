
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Offer{
  final List<dynamic> _listOfSessions;
  final String _price;
  final String _name;
  Offer(this._name, this._price, this._listOfSessions);

  String get name => _name;

  String get price => _price;

  List<dynamic> get listOfSessions => _listOfSessions;

  factory Offer.fromJson(dynamic json) => _offerFromJson(json);

  Map<String, dynamic> toJson() => {
    'name' : _name,
    'price': _price,
    'session': _listOfSessions,
  };
}

Offer _offerFromJson(dynamic json){
  return Offer(json['name'] as String, json['price'] as String, json['session'] as List<dynamic>);
}