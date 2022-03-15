import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExercises extends StatefulWidget {
  const AddExercises(this._exNames, {Key? key}) : super(key: key);
  final List<String> _exNames;

  @override
  _AddExercisesState createState() => _AddExercisesState();
}

class _AddExercisesState extends State<AddExercises> {
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  Map<String, dynamic> _exercises = {};
  int _exNr = 1;
  String _exName = '';

  void _addExRes(String _ex, String _res) async {
    if (_exercises.isEmpty) {
      print('here');
      SharedPreferences _shared = await SharedPreferences.getInstance();
      DateTime _dateTimeNow = DateTime.now();
      String _date = _dateTimeNow.toIso8601String();
      _shared.setString('date', _date);
    }
    setState(() {
      _exercises[_exNr.toString() + _ex] = _res;
    });
    _exNr++;
  }

  void _getStoredData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    DateTime _date = DateTime.parse(_shared.getString('date')!);
    if (DateTime.now().difference(_date) < const Duration(hours: 4)) {
      setState(() {
        String? s = _shared.getString('EX');
        _exercises = json.decode(s!);
      });
    }
  }

  void _saveData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    if (_exercises.isNotEmpty) {
      String _ex = json.encode(_exercises);
      _shared.setString('EX', _ex);
    } else {
      _shared.remove('EX');
    }
  }

  @override
  void initState() {
    _getStoredData();
    super.initState();
  }

  @override
  void dispose() {
    _saveData();
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
                    onPressed: () {
                      setState(() {
                        _exercises.remove(_string);
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
              padding: const EdgeInsets.all(20),
              child: Autocomplete(
                  onSelected: (value) => {
                        _exName = value as String,
                      },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return widget._exNames.where((String option) {
                      return option
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Reps',
                ),
                controller: _controller1,
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Weight',
                ),
                controller: _controller2,
                keyboardType: TextInputType.number,
              ),
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
                            title: Text(
                                _exercises.keys.elementAt(index).substring(1)),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () {
                      String loadNReps = _controller1.value.text + ' x ';
                      loadNReps += _controller2.value.text + 'kg';
                      if (loadNReps.isNotEmpty && _exName.isNotEmpty) {
                        _addExRes(_exName, loadNReps);
                      }
                      _controller1.clear();
                      _controller2.clear();
                      WidgetsBinding.instance?.focusManager.primaryFocus
                          ?.unfocus();
                    },
                    child: const Text('Add Exercise')),
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
