import 'dart:convert';

import 'package:crawl_course_3/session/excerise/gym_exercise.dart';
import 'package:crawl_course_3/session/excerise/gym_exercise_desc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../excerise/abs_exercise.dart';

class AddExercises extends StatefulWidget {
  const AddExercises(this._sport, {Key? key}) : super(key: key);
  final String _sport;

  @override
  _AddExercisesState createState() => _AddExercisesState();
}

class _AddExercisesState extends State<AddExercises> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final List<String> _exercisesList = [];
  final Map<String, Map<String, String>> _exSet = {};
  Map<String, dynamic> _exAdd = {};
  final Map<String, Exercise> _stringToEx = {};
  Map<String, GymExercise> _listOfExercises = {};
  String _exName = '';
  String _sessionStart = '';

  void _getAllExercises() async {
    DataSnapshot _snapS = await Exercise.exerciseRefStandard.get();
    for (DataSnapshot _ExTypes in _snapS.children) {
      for (DataSnapshot _data in _ExTypes.children) {
        final _ex = Exercise.fromJson(_data.value); //print(_data.value);
        try {
          _exercisesList.add(_ex.title);
          _stringToEx[_ex.title] = _ex;
          _exSet[_ex.title] = {
            'exCat': _ExTypes.key.toString(),
            'exType': _ex.other!['r_Type'].toString(),
            'userMade': _ex.other!['standard'].toString(),
          };
        } catch (e) {
          continue;
        }
      }
    }
    setState(() {});
  }

  void _getAllExercises2() async {
    _listOfExercises = await APIService().getData();
  }

  void _getStoredData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? _x = _shared.getString('date');
    if (_x != null && _x.isNotEmpty) {
      DateTime _date = DateTime.parse(_shared.getString('date')!);
      if (DateTime.now().difference(_date) < const Duration(hours: 4)) {
        setState(() {
          String? s = _shared.getString('EX');
          _exAdd = json.decode(s!);
        });
      }
    }
  }

  void _saveData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    if (_exAdd.isNotEmpty) {
      if (_exAdd.keys.length == 1) {}
      String _ex = json.encode(_exAdd);
      _shared.setString('date', DateTime.now().toString());
      _shared.setString('EX', _ex);
      setState(() {
        String min = '';
        if (DateTime.now().minute.toString().length == 1) {
          min = '0' + DateTime.now().minute.toString();
        } else {
          min = DateTime.now().minute.toString();
        }
        _sessionStart = DateTime.now().hour.toString() + ':' + min;
      });
    } else {
      _shared.remove('EX');
    }
  }

  @override
  void initState() {
    //_getAllExercises();
    _getAllExercises2();
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
                        _exAdd.remove(_string);
                        if (_exAdd.isEmpty) {
                          _shared.remove('EX');
                          _saveData();
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
        color: Colors.transparent,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Let´s work it!',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Text(_sessionStart),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Autocomplete(onSelected: (value) {
                _exName = value as String;
              }, optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _listOfExercises.keys.where((String option) {
                  return option.contains(textEditingValue.text);
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () async {
                    final _e = _listOfExercises[_exName];
                    _exAdd[_e!.name] = {};
                    _saveData();
                    _controller1.text = '';
                    _controller2.text = '';
                    _exName = '';
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
                itemCount: _exAdd.length,
                itemBuilder: (BuildContext context, int index) {
                  int _itemInList = index;
                  _itemInList++;
                  String _exName = _exAdd.keys.toList().elementAt(index);
                  return _exAdd.isNotEmpty
                      ? Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            _remove(_exName);
                          },
                          background: Container(
                            color: Colors.red.shade900,
                            child: const Center(child: Text('Remove')),
                          ),
                          child: Card(
                            child: ListTile(
                              onTap: () async {
                                GymExercise? _ex = _listOfExercises[_exName];
                                List<String>? _list =
                                    await _ex!.setUnitAndReps(context);
                                if (_list == null) {
                                  return;
                                }
                                List<String>? x =
                                    await _ex.addExerciseResult(context, _list);
                                if (x.length > 2) {
                                  List<String> _res = x.sublist(3);
                                  _exSet.putIfAbsent(
                                      _ex.name,
                                      () => {
                                            'set': _list.elementAt(1),
                                            'reps': _list.elementAt(2),
                                            'result': _res.toString()
                                          });
                                  setState(() {
                                    _exAdd[_ex.name] = _exSet[_ex.name];
                                  });
                                  _saveData();
                                }
                              },
                              onLongPress: () {
                                GymExercise? _ex = _listOfExercises[
                                    _exAdd.keys.elementAt(index)];
                                if (_ex != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GymExerciseDesc(exercise: _ex)));
                                }
                              },
                              leading: Text(_itemInList.toString()),
                              title: Text(_exName),
                              trailing:
                                  Text(_exAdd[_exName]['result'].toString()),
                            ),
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
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _list.where((String option) {
          return option.contains(textEditingValue.text);
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}
