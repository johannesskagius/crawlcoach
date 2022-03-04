import 'package:crawl_course_3/courses/course_info.dart';
import 'package:crawl_course_3/courses/offer.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'user2.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  Map<Object?, List<Object?>> _assigned = {};
  List<Offer> _assigned2 = [];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      //slivers: _sliverList(context, _assigned),
      slivers: _sliverList(context, _assigned2),
    );
  }

  @override
  void initState() {
    //_activateListener();
    _activateListener2();
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
    User2? _local = await User2.getLocalUser();
    final _databaseRef =
        _ref.child('users').child(_local!.userAuth).child('assigned_sessions');
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

  Future<void> _activateListener2() async {
    User2? _local = await User2.getLocalUser();
    final _databaseRef =
        _ref.child('users').child(_local!.userAuth).child('a_sessions');

    List<Offer> _offers = [];
    _databaseRef.onValue.listen((event) {
      for (DataSnapshot _courseName in event.snapshot.children) {
        print(_courseName.value.toString());
        _offers.add(Offer.fromJson(_courseName.value));
      }
      setState(() {
        _assigned2 = _offers;
      });
    });
  }
}

List<Widget> _sliverList(BuildContext context, List<Offer> _offers) {
  List<Widget> _widgets = [];
  _widgets.add(const SliverAppBar(
    flexibleSpace: FlexibleSpaceBar(
      title: Text('My courses', style: TextStyle(color: Colors.greenAccent)),
    ),
    expandedHeight: 50,
    floating: true,
  ));
  for (int _i = 0; _i < _offers.length; _i++) {
    String _courseName = _offers.elementAt(_i).name;
    _widgets
      ..add(SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(_courseName),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {
              print('here');
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
      ))
      ..add(SliverFixedExtentList(
        itemExtent: 50.0,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return SessionPreviewNoSession(
              _offers
                  .elementAt(_i)
                  .listOfSessions
                  .keys
                  .elementAt(index)
                  .toString(),
              _offers.elementAt(_i).userID);
        }, childCount: _offers.elementAt(_i).listOfSessions.length),
      ));
  }
  return _widgets;
}