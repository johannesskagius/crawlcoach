import 'dart:core';

import 'package:crawl_course_3/account/user2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'exercise_result.dart';

@JsonSerializable()
class Exercise {
  static final DatabaseReference exerciseRef =
      FirebaseDatabase.instance.ref().child('exercises');
  static final DatabaseReference exerciseRefUser =
      exerciseRef.child('userMade');
  static final DatabaseReference exerciseRefStandard =
      exerciseRef.child('standard');
  final String title, subTitle, perk1, perk2, perk3;
  String? url;
  final List<Object?> description;
  Map<Object?, Object?>? other;

  Exercise(this.url,
      {required this.title,
      required this.subTitle,
      required this.perk1,
      required this.perk2,
      required this.perk3,
        required this.description,
        required this.other});

  factory Exercise.fromJson(dynamic json) => _exerciseFromJson(json);

  Map<Object, dynamic> toJson() => {
        'title': title,
        'subTitle': subTitle,
        'perk1': perk1,
        'perk2': perk2,
        'perk3': perk3,
        'description': description,
        'url': url,
        'other': other,
      };

  @override
  String toString() {
    return 'Exercise{_title: $title, _subTitle: $subTitle}';
  }

  void uploadExercise(User2 _user, String _type) async {
    exerciseRefUser
        .child(_user.userAuth)
        .child(_type)
        .child(title)
        .set(toJson());
  }

  static Future<List<String>> setUnitAndReps(BuildContext context) async {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    String? dropdownvalue = 'meters';
    var _list = ['meters', 'minutes', 'seconds', 'kilometers', 'times'];
    String _result;
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How many repetitions?'),
        actions: [
          DropdownButton(
            value: dropdownvalue,
            items: _list.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) => {
              dropdownvalue = newValue,
            },
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Sets'),
            controller: _controller,
            keyboardType: TextInputType.number,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Reps',
            ),
            controller: _controller2,
            keyboardType: TextInputType.number,
              ),
              TextButton(
                  child: const Text("accept"),
                  onPressed: () {
                List<String> _res = [
                  _controller.value.text,
                  _controller2.value.text,
                  dropdownvalue.toString()
                  //TODO sätt så att man måste sätta typ
                ];
                Navigator.pop(context, _res);
              }),
            ],
          ),
    );
  }

  static Future<String> setUnitType(BuildContext context) async {
    String _dropdownValue = 'minutes';
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set unit type'),
        actions: [
          DropdownButton(
            items: <String>[
              'meters',
              'minutes',
              'seconds',
              'kilometers',
              'times'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {},
          ),
          TextButton(
              child: const Text("accept"),
              onPressed: () {
                Navigator.pop(context, _dropdownValue);
              }),
        ],
      ),
    );
  }

  Object? addExerciseResult(BuildContext context, String _repsSet) async {
    if (other!['r_Type'] == null) {
      other!['r_Type'] = await setUnitAndReps(context);
    }
    switch (other!['r_Type']) {
      case 'times':
        return _openAntalProg(context, _repsSet);
      case 'minutes':
      case 'seconds':
      case 'meters':
        break;
    }
    return null;
  }

  Object _openAntalProg(BuildContext context, String _repsSet) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseResult(this, _repsSet)));
  }
}

Exercise _exerciseFromJson(dynamic json) {
  return Exercise(json['url'],
      title: json['title'],
      subTitle: json['subTitle'],
      perk1: json['perk1'],
      perk2: json['perk2'],
      perk3: json['perk3'],
      description: json['description'],
      other: json['other']);
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
