import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'exercise_result.dart';

class GymExercise {
  static final DatabaseReference exerciseRef =
      FirebaseDatabase.instance.ref().child('exercises');
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String id;
  final String name;
  final String target;

  GymExercise(this.bodyPart, this.equipment, this.gifUrl, this.id, this.name,
      this.target);

  void _setExRes() async {}

  void _getExRes() async {}

  factory GymExercise.fromJson(dynamic json) => _gymFromJson(json);

  Map<Object, dynamic> toJson() => {
        'bodyPart': bodyPart,
        'equipment': equipment,
        'gifUrl': gifUrl,
        'id': id,
        'name': name,
        'target': target,
      };

  @override
  String toString() {
    return 'GymExercise{id: $id, name: $name, target: $target}';
  }

  Future<List<String>> _openAntalProg(
      BuildContext context, String _repsSet) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseResult(name, _repsSet)));
  }

  Future<List<String>> addExerciseResult(
      BuildContext context, List<String> _repsSet) async {
    String _type = _repsSet.elementAt(0) + ' x ' + _repsSet.elementAt(1);
    switch (_repsSet.elementAt(0)) {
      case 'reps':
        _repsSet.addAll(await _openAntalProg(context, _type));
        return _repsSet;
      case 'minutes':
      case 'seconds':
        break;
    }
    return _repsSet;
  }

  Future<List<String>?> setUnitAndReps(BuildContext context) async {
    final _controller = TextEditingController();
    String dropdownvalue = 'reps';
    var _list = ['minutes', 'seconds', 'reps'];
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
            onChanged: (String? newValue) {
              dropdownvalue = newValue.toString();
            },
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Reps',
            ),
            controller: _controller,
            keyboardType: TextInputType.number,
          ),
          TextButton(
              child: const Text("accept"),
              onPressed: () {
                List<String> _res = [
                  dropdownvalue,
                  _controller.value.text,
                ];
                print(_res.toString());
                Navigator.pop(context, _res);
              }),
        ],
      ),
    );
  }
}

GymExercise _gymFromJson(dynamic json) {
  return GymExercise(
    json['bodyPart'],
    json['equipment'],
    json['gifUrl'],
    json['id'],
    json['name'],
    json['target'],
  );
}

class APIService {
  static const _authority = "exercisedb.p.rapidapi.com";
  static const _path = "/exercises";
  static const Map<String, String> _headers = {
    "x-rapidapi-key": "67e1dc9766mshf42537bd2c7994bp154ba6jsn159a34d700ae",
    "x-rapidapi-host": "exercisedb.p.rapidapi.com",
  };

  // Base API request to get response
  Future<Map<String, GymExercise>> getData() async {
    //Future<String> getData() async {
    Uri uri = Uri.https(_authority, _path);

    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      List<dynamic> jsonMap = jsonDecode(response.body);
      Map<String, GymExercise> _listOFEx = {};
      for (dynamic x in jsonMap) {
        //_listOFEx.add(GymExercise.fromJson(x));
        final _ex = GymExercise.fromJson(x);
        _listOFEx[_ex.name] = _ex;
      }
      return _listOFEx;
    } else {
      // If that response was not OK, throw an error.
      print('error');
      throw Exception(
          'API call returned: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
