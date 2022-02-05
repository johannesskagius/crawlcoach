import 'package:crawl_course_3/account/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  Map<Object?, List<Object?>> _assigned = {};

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: _sliverList(_assigned),
    );
  }

  @override
  void initState() {
    _activateListener();
    super.initState();
  }

  void markPressed() {
    setState(() {});
  }

  Future<void> _activateListener() async {
    LocalUser? _local = await LocalUser.getLocalUser();
    final _databaseRef =
        _ref.child('users').child(_local!.userAuth2).child('assigned_sessions');
    Map<Object?, List<Object?>> _ex = {};

    _databaseRef.onValue.listen((event) {
      for (DataSnapshot _courseName in event.snapshot.children) {
        if (!_ex.containsKey(_courseName)) {
          // print(_courseName.key.toString());
          // print(_courseName.value.toString());

          // List<String> _sessions= ;
          _ex.putIfAbsent(
              _courseName.key, () => _courseName.value as List<Object?>);
          // print(_ex.toString());
        }
      }
      setState(() {
        _assigned = _ex;
      });
    });
  }
}

List<Widget> _sliverList(Map<Object?, List<Object?>> _map) {
  List<Widget> _widgets = [];
  print(_map.toString());

  for (int _i = 0; _i < _map.keys.length; _i++) {
    _widgets
      ..add(SliverAppBar(
        title: Text(_map.keys.elementAt(_i).toString()),
        pinned: true,
      ))
      ..add(SliverFixedExtentList(
        itemExtent: 50.0,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            color: Colors.lightBlue[100 * (index % 9)],
            child: Text('list item $index'),
          );
        }, childCount: _map.values.length),
      ));
  }
  return _widgets;
}

SliverFixedExtentList _sliverFixed(List<Object?> _list, int values) {
  return SliverFixedExtentList(
    itemExtent: 50.0,
    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return Container(
        alignment: Alignment.center,
        color: Colors.lightBlue[100 * (index % 9)],
        child: Text('list item $index'),
      );
    }, childCount: values),
  );
}