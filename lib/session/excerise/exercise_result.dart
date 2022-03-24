import 'package:crawl_course_3/account/user2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExerciseResult extends StatefulWidget {
  const ExerciseResult(this._exTitle, this._type, {Key? key}) : super(key: key);
  final String _exTitle;
  final String _type;

  @override
  _ExerciseResultState createState() => _ExerciseResultState();
}

class _ExerciseResultState extends State<ExerciseResult> {
  final List<BarChartGroupData> _barData = [];
  Map<String, Map<Object, Object>> _resultMap = {};
  Map<Object, Object> _userRes = {};
  List<double> _earlierResult = [];
  List<double> _todaysRes = [];
  int j = 0;

  double _maxY = 0;

  Future<void> _getData() async {
    final user = await User2.getLocalUser();
    DataSnapshot _data = await User2.ref
        .child(user!.userAuth)
        .child('r_exercise')
        .child(widget._exTitle)
        .get();
    for (DataSnapshot x in _data.children) {
      List<double> _results = [];
      for (DataSnapshot x2 in x.children) {
        if (x2.key != null && x2.key != 'set_type') {
          double _res = double.parse(x2.value.toString());
          if (x.key.toString() == _getToday()) {
            _earlierResult.add(_res);
          } else {
            _results.add(_res);
          }
          if (_res > _maxY) {
            _maxY = _res;
          }
        }
      }
      setState(() {
        _barData.add(_makeGroupData(int.parse(x.key.toString()), _results));
      });
    }
  }

  void _uploadRes() async {
    final user = await User2.getLocalUser();
    _userRes['set_type'] = widget._type;
    _resultMap[_getToday()] = _userRes;
    User2.ref
        .child(user!.userAuth)
        .child('r_exercise')
        .child(widget._exTitle)
        .update(_resultMap);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _getData().whenComplete(() =>
        _barData.add(_makeGroupData(int.parse(_getToday()), _earlierResult)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<double> getResult(int i) async {
      final _controller = TextEditingController();
      j = i + 1;
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
                  double _loadForSet = 10;
                  _loadForSet = double.parse(_controller.value.text);
                  Navigator.pop(context, _loadForSet);
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
                  double _res = await getResult(_earlierResult.length);
                  _userRes[_earlierResult.length.toString()] = _res;
                  _todaysRes.add(_res);
                  _barData.removeLast();
                  setState(() {
                    _earlierResult.add(_res);
                    _barData.add(
                        _makeGroupData(int.parse(_getToday()), _earlierResult));
                    if (_res > _maxY) {
                      _maxY = _res;
                    }
                  });
                },
                child: const Text('Add result')),
            ElevatedButton(
                onPressed: () {
                  if (_earlierResult.isEmpty) {
                    _barData.removeLast();
                  } else {
                    //_uploadRes();
                    List<String> _res = [j.toString()];
                    for (double x in _todaysRes) {
                      _res.add(x.toString());
                    }
                    Navigator.pop(context, _res);
                  }
                },
                child: const Text('go back'))
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
}
