import 'package:crawl_course_3/courses/course_info.dart';
import 'package:crawl_course_3/courses/offer.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../store.dart';
import 'user2.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({Key? key}) : super(key: key);

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  List<Offer> _assigned2 = [];
  bool isSignedIn = false;

  void _setSignedIn() {
    setState(() {
      isSignedIn = User2.firebaseAuth.currentUser!.isAnonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn || _assigned2.isEmpty
        ? const Center(
            child: Text('Sign in to see your courses here'),
          )
        : Scrollbar(
            child: CustomScrollView(
              slivers: _sliverList(context, _assigned2),
            ),
          );
  }

  @override
  void initState() {
    _setSignedIn();
    _activateListener();
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

  Future<void> _activateListener() async {
    if (User2.firebaseAuth.currentUser!.isAnonymous) {
      return;
    }
    User2? _local = await User2.getLocalUser();
    List<Offer> _offers = [];
    _ref
        .child('users')
        .child(_local!.userAuth)
        .child('a_sessions')
        .onValue
        .listen((event) async {
      for (DataSnapshot _courseName in event.snapshot.children) {
        if (!_courseName.hasChild('session')) {
          String course = _courseName.key.toString();
          User2.ref
              .child(_local.userAuth)
              .child('c_courses')
              .child(course)
              .set(_courseName.value);
          User2.ref
              .child(_local.userAuth)
              .child('a_sessions')
              .child(course)
              .remove();
          break;
        }
        Offer newOffer = Offer.fromJson(_courseName.value);
        if (!_offers.contains(newOffer)) {
          _offers.add(newOffer);
        }
      }
      setState(() {
        _assigned2 = _offers;
      });
    });
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
