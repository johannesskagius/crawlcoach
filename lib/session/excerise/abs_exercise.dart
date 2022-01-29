import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

@JsonSerializable()
class Exercise {
  String _title, _subTitle;
  String _perk1, _perk2, _perk3;
  List<dynamic> _description;
  Exercise(this._title, this._subTitle, this._perk1, this._perk2, this._perk3,this._description);

  get subTitle => _subTitle;

  factory Exercise.fromJson(dynamic json) => _exerciseFromJson(json);

  Map<String, dynamic> toJson() => {
    'title' : title,
    'subTitle': subTitle,
    'perk1': _perk1,
    'perk2': _perk2,
    'perk3': _perk3,
    'description': description,
  };

  List<dynamic> get description => _description;
  String get title => _title;
  String get perk1 => _perk1;
  get perk2 => _perk2;
  get perk3 => _perk3;

  @override
  String toString() {
    return 'Exercise{_title: $_title, _subTitle: $_subTitle}';
  }
}

Exercise _exerciseFromJson(dynamic json) {
  return Exercise(
      json['title'] as String,
      json['subTitle'] as String,
      json['perk1'] as String,
      json['perk2'] as String,
      json['perk3'] as String,
      json['description'] as List<dynamic>);
}


Future<void> loadToFireBase(Exercise exercise) async {
  final DatabaseReference database = FirebaseDatabase.instance.ref('exercises');
  database.push();
}

class Explained extends StatelessWidget {
  const Explained(
      {Key? key,
      required this.number,
      required this.description,
      required this.width})
      : super(key: key);
  final String number, description;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: width * 0.1,
              child: Title(color: Colors.white, child: Text(number, style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),))),
          SizedBox(
              width: width * 0.8,
              child: Wrap(
                children: [Text(description, style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),)],
              ))
        ],
      ),
    );
  }
}

class Perks extends StatelessWidget {
  const Perks({Key? key, required this.perk, required this.iconData})
      : super(key: key);
  final IconData iconData;
  final String perk;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(iconData),
          Text(perk),
        ],
      ),
    );
  }
}


