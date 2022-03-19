import 'dart:convert';

import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../account/user2.dart';

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  Map<String, dynamic> _exercises = {};
  Duration? _sessDur;
  final _contoller = TextEditingController();
  final _contoller2 = TextEditingController();

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

  void _getWorkOutTime() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    DateTime _date = DateTime.parse(_shared.getString('date')!);
    setState(() {
      _sessDur = DateTime.now().difference(_date);
    });
  }

  @override
  void initState() {
    _getStoredData();
    _getWorkOutTime();
    super.initState();
  }

  void _unBind() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    return GestureDetector(
      onTap: _unBind,
      child: Container(
        margin: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Great job!',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            _sessDur != null
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('This session took: '),
                        Text(_sessDur!.inMinutes.toString() + 'min'),
                      ],
                    ),
                  )
                : Container(),
            TextField(
              controller: _contoller,
              decoration: const InputDecoration(
                  hintText: 'Would you like to save this session?'),
              keyboardType: TextInputType.name,
            ),
            TextField(
              controller: _contoller2,
              decoration: const InputDecoration(
                  hintText: 'Would you like to save this session?'),
              keyboardType: TextInputType.name,
            ),
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
                              //_remove(_exercises.keys.elementAt(index));
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
            ElevatedButton(
                onPressed: _exercises.keys.isNotEmpty
                    ? () async {
                        final _user = await User2.getLocalUser();
                        //Upload t res
                        _upLoadRes(_user);
                        if (_contoller.value.text.isNotEmpty) {
                          //Create a session,
                          _upLoadPrivate(_user!);
                        }
                        await _resetSess();
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Completed'))
          ],
        ),
      ),
    );
  }

  void _upLoadRes(User2? _user) {
    Map<String, Map<String, Object?>> result = {};
    Set<String> _addedNames = {};

    int i = 0;
    for (String _exName in _exercises.keys) {
      String _exNameFormatted = _exName.substring(1);
      if (!_addedNames.contains(_exNameFormatted)) {
        i = 0;
      }
      String _info = _exercises[_exName].toString();
      _info = _info.substring(1, _info.length - 1);
      //result[_exNameFormatted] = {'set_type': _info.replaceFirst(', ', '')} //TODO add sets and reps to info
      _info = _info.split(',').elementAt(1).trim();
      result[_exNameFormatted] = {i.toString(): double.parse(_info)};
      User2.ref
          .child(_user!.userAuth)
          .child('r_exercise')
          .child(_exNameFormatted)
          .child(_getToday())
          .update({i.toString(): double.parse(_info)});
      result.clear();
      i++;
      _addedNames.add(_exNameFormatted);
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

  void _upLoadPrivate(User2 _user) {
    _exercises = _format();
    Session _mySession = Session(
        sessionName: _contoller.value.text,
        desc: _contoller2.value.text,
        exercises: _exercises,
        videoUrl: 'n');
    User2.ref
        .child(_user.userAuth)
        .child('my_sessions')
        .child(_mySession.sessionName)
        .set(_mySession.toJson());
  }

  Future<void> _resetSess() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    //remove all
    _shared.remove('EX');
    _shared.remove('date');
  }

  Map<String, dynamic> _format() {
    Map<String, Object> _formated = {};
    for (String x in _exercises.keys) {
      String _name = x.substring(1);
      _formated[_name] = _exercises[x];
    }
    return _formated;
  }
}
