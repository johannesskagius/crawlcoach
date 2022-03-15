import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  _OverViewState createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  Map<String, dynamic> _exer = {};
  Map<String, List<String>> _exerPresent = {};
  Duration? _sessDur;

  void _loadNCountEx() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? s = _shared.getString('EX');
    _exer = json.decode(s!);
    for (String _x in _exer.keys) {
      String _exName = _x.substring(1);
      if (_exerPresent.containsKey(_exName)) {
        String _resr = _exer[_x].toString();
        _exerPresent[_exName]!.add(_resr);
      } else {
        List<String> _list = [_exName];
        _exerPresent[_exName] = _list;
      }
    }
    setState(() {});
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
    _loadNCountEx();
    _getWorkOutTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Great job!'),
        _sessDur != null ? Text(_sessDur!.inMinutes.toString()) : Container(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _exerPresent.keys.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(_exerPresent.keys.elementAt(index)),
                trailing: Text(
                    _exerPresent.values.elementAt(index).length.toString()),
              ),
            );
          },
        ),
        ElevatedButton(
            onPressed: () async {
              SharedPreferences _shared = await SharedPreferences.getInstance();
              //remove all
              _shared.remove('EX');
              _shared.remove('date');
              Navigator.pop(context);
            },
            child: const Text('Completed'))
      ],
    );
  }
}
