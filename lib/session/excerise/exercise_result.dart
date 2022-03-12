import 'package:crawl_course_3/account/user2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'abs_exercise.dart';

class ExerciseResult extends StatefulWidget {
  const ExerciseResult(this._exercise, this._type, {Key? key})
      : super(key: key);
  final Exercise _exercise;
  final String _type;

  @override
  _ExerciseResultState createState() => _ExerciseResultState();
}

class _ExerciseResultState extends State<ExerciseResult> {
  final List<BarChartGroupData> _barData = [];
  double _maxY = 0;

  Future<void> _getData() async {
    final user = await User2.getLocalUser();
    DataSnapshot _data = await User2.ref
        .child(user!.userAuth)
        .child('r_exercise')
        .child(widget._exercise.title)
        .get();
    int i = 0;
    for (DataSnapshot x in _data.children) {
      int key = int.parse(x.key.toString());
      String newValues =
          x.value.toString().substring(1, x.value.toString().length - 1);
      List<String> xx = newValues.split(',');
      List<double> xxx = [];
      try {
        for (String s in xx) {
          double _val = double.parse(s);
          xxx.add(_val);
          if (_maxY < _val) {
            _maxY = _val;
          }
        }
        _barData.add(_makeGroupData(key, xxx));
      } catch (e) {
        continue;
      }

      i++;
      if (i == 7) {
        break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<double> getResult(int i) async {
      final _controller = TextEditingController();
      int j = i + 1;
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('$j: set'),
          actions: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _controller,
            ),
            TextButton(
                child: const Text("Add"),
                onPressed: () {
                  double x = 2;
                  x = double.parse(_controller.value.text);
                  Navigator.pop(context, x);
                }),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Results'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                    maxY: _maxY * 1.2,
                    titlesData: _getTitles(),
                    barGroups: _barData),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Best set: ' + _maxY.toString()),
                  const Text('55'),
                  const Text('55'),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  Map<String, Map<Object, Object>> result = {};
                  Map<Object, Object> _userRes = {};
                  final user = await User2.getLocalUser();
                  int antal = int.parse(widget._type.substring(0,
                      1)); //TODO lås i addsession så att det är en siffra som första tecken.
                  for (int i = 0; i < antal; i++) {
                    _userRes[i] = (await getResult(i));
                  }
                  _userRes['set_type'] = widget._type;
                  String nowString = getToday();
                  result[nowString.toString()] = _userRes;

                  User2.ref
                      .child(user!.userAuth)
                      .child('r_exercise')
                      .child(widget._exercise.title)
                      .update(result)
                      .onError((error, stackTrace) => print('error'))
                      .whenComplete(() => Navigator.pop(context));
                },
                child: const Text('Add result')),
          ],
        ),
      ),
    );
  }

  String getToday() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() + month + now.year.toString();
  }
}

BarChartGroupData _makeGroupData(int _date, List<double> _resOnDate) {
  List<BarChartRodData> _rods = []; // BarChartRodData(toY: y, width: 15)
  for (double s in _resOnDate) {
    _rods.add(BarChartRodData(toY: s, width: 10));
  }
  return BarChartGroupData(x: _date, barsSpace: 8, barRods: _rods);
}

FlTitlesData _getTitles() {
  return FlTitlesData(
      //12032022
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
          showTitles: true,
          margin: 8,
          reservedSize: 28,
          rotateAngle: 45,
          getTitles: (double value) {
            String _date = value.toString().substring(0, 2);
            String _month = value.toString().substring(2, 4);
            String _m = _getMonth(_month);
            return _date + ' $_m';
          }));
}

String _getMonth(String _month) {
  switch (_month) {
    case '01':
      return 'January';
    case '02':
      return 'February';
    case '03':
      return 'Mars';
    case '04':
      return 'April';
    case '05':
      return 'May';
    case '06':
      return 'June';
    case '07':
      return 'July';
    case '08':
      return 'August';
    case '09':
      return 'September';
    case '10':
      return 'October';
    case '11':
      return 'November';
    case '12':
      return 'December';
  }
  return '';
}
