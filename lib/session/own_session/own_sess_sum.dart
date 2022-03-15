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
    setState(() {
      _exerPresent;
    });
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

  void _unBind() {
    setState(() {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            const TextField(
              decoration: InputDecoration(
                  hintText: 'Would you like to save this session?'),
              keyboardType: TextInputType.name,
            ),
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
                onPressed: _exerPresent.keys.isNotEmpty
                    ? () async {
                        SharedPreferences _shared =
                            await SharedPreferences.getInstance();
                        //remove all
                        _shared.remove('EX');
                        _shared.remove('date');
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Completed'))
          ],
        ),
      ),
    );
  }
}
