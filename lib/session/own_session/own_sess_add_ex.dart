import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../excerise/abs_exercise.dart';
import '../excerise/exercise_result.dart';

class AddExercises extends StatefulWidget {
  const AddExercises({Key? key}) : super(key: key);

  @override
  _AddExercisesState createState() => _AddExercisesState();
}

class _AddExercisesState extends State<AddExercises> {
  Map<String, Map<String, String>> _exNames = {}; //Exercise type, Exercise Name
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Map<String, List<Object>> _exercises = {};
  List<String> _exercisesList = [];
  Map<String, Set<String>> _exStandard = {};
  Map<String, String> _exCat = {};
  String _exName = '';

  void _addExRes(String _ex, String _reps, String _weight) async {
    if (_exercises.isEmpty) {
      SharedPreferences _shared = await SharedPreferences.getInstance();
      DateTime _dateTimeNow = DateTime.now();
      String _date = _dateTimeNow.toIso8601String();
      _shared.setString('date', _date);
    }
    setState(() {
      _exercises[_exercises.length.toString() + _ex] = [_reps, _weight];
    });
    _saveData();
  }

  void _getAllExercises() async {
    DataSnapshot _data = await Exercise.exerciseRefStandard.get();
    for (DataSnapshot _exType in _data.children) {
      for (DataSnapshot _exName in _exType.children) {
        if (_exNames.containsKey(_exType.key.toString())) {
          //_exNames[_exType.key.toString()]!.add(_exName.key.toString());
//          Map<String, Map<String, String>> _exNames = {}; //Exercise type, Exercise Name
          _exNames['standard']!.putIfAbsent(
              _exName.key.toString(), () => _exType.key.toString());
        } else {
          Map<String, String> _map = {
            _exName.key.toString(): _exType.key.toString()
          };
          _exNames['standard'] = _map;
        }
        _exStandard
            .putIfAbsent('standard', () => <String>{})
            .add(_exName.key.toString());
        _exercisesList.add(_exName.key.toString());
        _exCat[_exName.key.toString()] = _exType.key.toString();
      }
    }
    setState(() {});
  }

  void _getStoredData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? _x = _shared.getString('date');
    print(_x);
    if (_x != null && _x.isNotEmpty) {
      DateTime _date = DateTime.parse(_shared.getString('date')!);
      if (DateTime.now().difference(_date) < const Duration(hours: 4)) {
        setState(() {
          String? s = _shared.getString('EX');
          _exercises = json.decode(s!);
        });
      }
    }
  }

  void _saveData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    if (_exercises.isNotEmpty) {
      print('e');
      String _ex = json.encode(_exercises);

      _shared.setString('date', DateTime.now().toString());
      _shared.setString('EX', _ex);
    } else {
      _shared.remove('EX');
    }
  }

  @override
  void initState() {
    _getAllExercises();
    _getStoredData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _unFocus() {
    setState(() {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    });
  }

  void _remove(String _string) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove exercise'),
          actions: [
            TextButton(
                onPressed: () async {
                  SharedPreferences _shared =
                  await SharedPreferences.getInstance();
                  setState(() {
                    _exercises.remove(_string);
                    if (_exercises.isEmpty) {
                      _shared.remove('EX');
                    } else {
                      _saveData();
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Remove Exercise')),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return GestureDetector(
      onTap: () {
        _unFocus();
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller1,
                decoration: const InputDecoration(
                  hintText: 'Sets',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller2,
                decoration: const InputDecoration(
                  hintText: 'Reps',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: //AutocompleteBasicExample(_exercisesList),
                  Autocomplete(onSelected: (value) {
                _exName = value as String;
              }, optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _exercisesList.where((String option) {
                  return option.contains(textEditingValue.text);
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () async {
                    String _set = _controller1.value.text;
                    String _reps = _controller2.value.text;
                    DataSnapshot? _exSnap;
                    bool _isStandard =
                        _exStandard['standard']!.contains(_exName);
                    String? _ex_Type = '';
                    if (_isStandard) {
                      _ex_Type = _exCat[_exName];
                      _exSnap = await Exercise.exerciseRefStandard
                          .child(_ex_Type!)
                          .child(_exName)
                          .get();
                    } else {
                      _exSnap = await Exercise.exerciseRefUser
                          .child(_ex_Type)
                          .child(_exName)
                          .get();
                    }
                    final _ex = Exercise.fromJson(_exSnap.value);
                    Map<String, Map<Object, Object>> _result = {};
                    _result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ExerciseResult(_ex, '$_set x $_reps times')));
                    String nowString = _getToday();
                    for (Object x in _result[nowString]!.values) {
                      try {
                        double _x = double.parse(x.toString());
                        setState(() {
                          _exercises.putIfAbsent(_exName, () => []).add(_x);
                        });
                      } catch (e) {
                        continue;
                      }
                    }
                    _saveData();
                    _controller1.text = '';
                    _controller2.text = '';
                    WidgetsBinding.instance?.focusManager.primaryFocus
                        ?.unfocus();
                  },
                  child: const Text('Add Exercise')),
            ),
            _divider(),
            SizedBox(
              height: _height * .5,
              child: ListView.builder(
                key: const PageStorageKey<String>('Page1'),
                shrinkWrap: true,
                itemCount: _exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  int _itemInList = index;
                  _itemInList++;
                  return _exercises.isNotEmpty
                      ? Card(
                    child: ListTile(
                      onTap: () {
                              _remove(_exercises.keys.elementAt(index));
                            },
                            leading: Text(_itemInList.toString()),
                            title: Text(_exercises.keys.elementAt(index)),
                            trailing: Text(
                                _exercises.values.elementAt(index).toString()),
                          ),
                  )
                      : const ListTile(
                    title: Text('Complete first exercise'),
                  );
                },
              ),
            ),
            _divider(),
          ],
        ),
      ),
    );
  }
}

String _getToday() {
  final now = DateTime.now();
  String month = now.month.toString();
  if (now.month < 10) {
    month = '0' + now.month.toString();
  }
  return now.day.toString() + month + now.year.toString();
}

Divider _divider() {
  return const Divider(
    height: 2,
  );
}

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample(this._list, {Key? key}) : super(key: key);
  final List<String> _list;

  @override
  Widget build(BuildContext context) {
    // print(_list.to);
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _list.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}