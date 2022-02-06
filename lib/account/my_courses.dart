import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/admin/courses/course_info.dart';
import 'package:crawl_course_3/session/session.dart';
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
      slivers: _sliverList(context, _assigned),
    );
  }

  @override
  void initState() {
    _activateListener();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          _ex.putIfAbsent(
              _courseName.key, () => _courseName.value as List<Object?>);
        }
      }
      setState(() {
        _assigned = _ex;
      });
    });
  }
}

List<Widget> _sliverList(
    BuildContext context, Map<Object?, List<Object?>> _map) {
  List<Widget> _widgets = [];
  _widgets.add(const SliverAppBar(
    flexibleSpace: FlexibleSpaceBar(
      title: Text('My courses', style: TextStyle(color: Colors.greenAccent)),
    ),
    expandedHeight: 50,
    floating: true,
  ));
  for (int _i = 0; _i < _map.keys.length; _i++) {
    String _courseName = _map.keys.elementAt(_i).toString();
    _widgets
      ..add(SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(_courseName),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseInfo(
                            courseName: _courseName,
                          )));
            },
          )
      ],
      expandedHeight: 50,
      floating: true,
    ))..add(SliverFixedExtentList(
      itemExtent: 50.0,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return SessionPreviewNoSession(
              _map.values.elementAt(_i).elementAt(index).toString());
        }, childCount: _map.values.elementAt(_i).length),
    ));
  }
  return _widgets;
}