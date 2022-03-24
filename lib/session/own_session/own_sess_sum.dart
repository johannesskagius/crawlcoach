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
  Map<String, dynamic> _exSet = {};
  Duration? _sessDur;
  final _contoller = TextEditingController();
  final _contoller2 = TextEditingController();

  void _getStoredData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? _startDate = _shared.getString('date');
    if (_startDate != null) {
      DateTime _date = DateTime.parse(_startDate);
      if (DateTime.now().difference(_date) < const Duration(hours: 4)) {
        setState(() {
          String? s2 = _shared.getString('EX');
          _exSet = jsonDecode(s2!);
        });
      }
    }
  }

  void _getWorkOutTime() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? _workOutStart = _shared.getString('date');
    if (_workOutStart != null) {
      DateTime _date = DateTime.parse(_shared.getString('date')!);
      setState(() {
        _sessDur = DateTime.now().difference(_date);
      });
    }
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

  void _uploadRes(
      String _name, User2 _user, Map<String, String> _resultMap) async {
    print(_name);
    print(_resultMap.toString());
    User2.ref
        .child(_user.userAuth)
        .child('r_exercise')
        .child(_name)
        .child(_getToday())
        .update(_resultMap);
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
                itemCount: _exSet.length,
                itemBuilder: (BuildContext context, int index) {
                  int _itemInList = index;
                  _itemInList++;
                  String _exName = _exSet.keys.elementAt(index);
                  return _exSet.isNotEmpty
                      ? Card(
                          child: ListTile(
                            onTap: () {
                              //_remove(_exercises.keys.elementAt(index));
                            },
                            leading: Text(_itemInList.toString()),
                            title: Text(_exName),
                            trailing: Text(_exSet[_exName]['result']),
                          ),
                        )
                      : const ListTile(
                          title: Text('Complete first exercise'),
                        );
                },
              ),
            ),
            ElevatedButton(
                onPressed: _exSet.keys.isNotEmpty
                    ? () async {
                  final _user = await User2.getLocalUser();
                        for (String s in _exSet.keys) {
                          Map<String, String> _resMap = {};
                          String _x = _exSet[s]['result'].toString();
                          _x = _x.substring(1, _x.length - 1);
                          for (String ss in _x.split(',')) {
                            _resMap[_resMap.keys.length.toString()] =
                                ss.toString();
                          }
                          _resMap['set'] = _exSet[s]['set'];
                          _resMap['reps'] = _exSet[s]['reps'];
                          _uploadRes(s, _user!, _resMap);
                        }

                        if (_contoller.value.text.isNotEmpty) {
                          _upLoadPrivate(_user!); //Create private session
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


  String _getToday() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() + month + now.year.toString();
  }

  void _upLoadPrivate(User2 _user) {
    Session _mySession = Session(
        _sessDur!.inMinutes.toString() + 'min', 'Gym',
        sessionName: _contoller.value.text,
        desc: _contoller2.value.text,
        exercises: _exSet,
        videoUrl: 'n');

    User2.ref
        .child(_user.userAuth)
        .child('my_sessions')
        .child(_mySession.sessionName)
        .set(_mySession.toJson());
  }

  Future<void> _resetSess() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    _shared.remove('EX');
    _shared.remove('date');
  }
}
