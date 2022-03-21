import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../excerise/abs_exercise.dart';

class AddExercises extends StatefulWidget {
  const AddExercises({Key? key}) : super(key: key);

  @override
  _AddExercisesState createState() => _AddExercisesState();
}

class _AddExercisesState extends State<AddExercises> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Map<String, dynamic> _exercises = {};
  List<String> _exercisesList = [];
  Map<String, Map<String, String>> _exSet = {};
  Map<String, Map<String, String>?> _exAdd = {};
  Map<String, Exercise> _stringToEx = {};
  String _exName = '';

  void _getAllExercises2() async {
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

  void _getStoredData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? _x = _shared.getString('date');
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
    if (_exAdd.isNotEmpty) {
      String _ex = json.encode(_exAdd);
      _shared.setString('date', DateTime.now().toString());
      _shared.setString('EX', _ex);
    } else {
      _shared.remove('EX');
    }
  }

  @override
  void initState() {
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
                        _exercises.remove(_string);
                        if (_exercises.isEmpty) {
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
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    List<String> _list = await Exercise.setUnitAndReps(context);
                    final _e = _stringToEx[_exName];
                    String _repsNSet =
                        _list.elementAt(0) + ' + ' + _list.elementAt(1);
                    Object? x = _e!.addExerciseResult(context, _repsNSet);
                    if (x != null) {
                      _exSet.putIfAbsent(_e.title, () => {}).addAll({
                        'set': _list.elementAt(0),
                        'reps': _list.elementAt(1),
                      });
                      _exAdd[_e.title] = _exSet[_e.title];
                      _saveData();
                      _controller1.text = '';
                      _controller2.text = '';
                    }
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
                  return _exAdd.isNotEmpty
                      ? Card(
                          child: ListTile(
                            onTap: () {
                              _remove(_exAdd.keys.elementAt(index));
                            },
                            leading: Text(_itemInList.toString()),
                            title: Text(_exAdd.keys.elementAt(index)),
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
