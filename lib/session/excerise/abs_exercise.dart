import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Exercise {
  static final DatabaseReference exerciseRef =
      FirebaseDatabase.instance.ref().child('exercises');
  final String title, subTitle;
  final String perk1, perk2, perk3;
  String? url;
  final List<Object?> description;

  Exercise(this.url,
      {required this.title,
      required this.subTitle,
      required this.perk1,
      required this.perk2,
      required this.perk3,
      required this.description});

  factory Exercise.fromJson(dynamic json) => _exerciseFromJson(json);

  Map<Object, dynamic> toJson() =>
      {
        'title': title,
        'subTitle': subTitle,
        'perk1': perk1,
        'perk2': perk2,
        'perk3': perk3,
        'url': url,
        'description': description,
      };

  @override
  String toString() {
    return 'Exercise{_title: $title, _subTitle: $subTitle}';
  }
}

Exercise _exerciseFromJson(dynamic json) {
  return Exercise(json['url'],
      title: json['title'],
      subTitle: json['subTitle'],
      perk1: json['perk1'],
      perk2: json['perk2'],
      perk3: json['perk3'],
      description: json['description']);
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
              child: Title(
                  color: Colors.white,
                  child: Text(
                    number,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ))),
          SizedBox(
              width: width * 0.8,
              child: Wrap(
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
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
