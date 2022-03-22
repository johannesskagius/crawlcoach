import 'package:crawl_course_3/courses/course_info.dart';
import 'package:crawl_course_3/courses/offer.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

import '../store.dart';
import 'user2.dart';

class MyCourses extends StatefulWidget {
  MyCourses(this._assigned2, {Key? key}) : super(key: key);
  List<Offer> _assigned2 = [];

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  bool _isSignedIn = false;

  void _setSignedIn() {
    setState(() {
      if (User2.firebaseAuth.currentUser!.uid.isNotEmpty) {
        _isSignedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) {
      return Scrollbar(
        child: CustomScrollView(
          slivers: _sliverList(context, widget._assigned2),
        ),
      );
    } else {
      return const Center(
        child: Text('Sign in to see your courses here'),
      );
    }
  }

  @override
  void initState() {
    _setSignedIn();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

List<Widget> _sliverList(BuildContext context, List<Offer> _offers) {
  List<Widget> _widgets = [];
  _widgets.add(SliverAppBar(
    flexibleSpace: const FlexibleSpaceBar(
      title: Text('Courses'),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Store()));
        },
      )
    ],
  ));
  for (int _i = 0; _i < _offers.length; _i++) {
    String _courseName = _offers.elementAt(_i).name;
    _widgets
      ..add(SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            _courseName,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CourseInfo(
                            courseName: _offers.elementAt(_i),
                          )));
            },
          )
        ],
        expandedHeight: 50,
        floating: true,
      ))
      ..add(SliverFixedExtentList(
        itemExtent: 60.0,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return SessionPreviewNoSession(
              _offers
                  .elementAt(_i)
                  .listOfSessions
                  .keys
                  .elementAt(index)
                  .toString(),
              _offers.elementAt(_i).userID,
              _courseName);
        }, childCount: _offers.elementAt(_i).listOfSessions.length),
      ));
  }
  return _widgets;
}
