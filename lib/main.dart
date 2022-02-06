import 'dart:async';

import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'account/my_courses.dart';
import 'admin/add_exercises_admin.dart';
import 'admin/add_session/add_session.dart';
import 'admin/admin.dart';
import 'admin/courses/add_offer.dart';
import 'home.dart';
import 'store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/addsession': (context) => const AddSession(),
        '/addoffer': (context) => const AddOffer(),
        '/addexercise': (context) => const AddExercise(),
      },
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: const Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final PageController pControll = PageController();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isManager = false;
  int _selected = 0;

  Future<bool> _activateListener() async {
    try {
      final _localUser = await LocalUser.getLocalUser();
      UserCredential _usercred = await _auth.signInWithEmailAndPassword(
          email: _localUser!.email, password: _localUser.password);
      DataSnapshot checkIfAdmin = await _ref
          .child('admins')
          .child(_usercred.user!.uid)
          .child('isadmin')
          .get();
      if (checkIfAdmin.value.toString() == 'true') {
        return Future<bool>.value(true);
      } else {
        return Future<bool>.value(false);
      }
    } catch (e) {
      //Download anonymous user
      if (e == Exception) {}
      return Future<bool>.value(false);
    }
  }

  Future<void> _isManager() async {
    try {
      final _localUser = await LocalUser.getLocalUser();
      UserCredential _usercred = await _auth.signInWithEmailAndPassword(
          email: _localUser!.email, password: _localUser.password);
      DataSnapshot checkIfAdmin = await _ref
          .child('admins')
          .child(_usercred.user!.uid)
          .child('isadmin')
          .get();
      if (checkIfAdmin.value.toString() == 'true') {
        setState(() {
          isManager = true;
        });
      }
    } catch (e) {
      //Download anonymous user
      if (e == Exception) {}
      //return Future<bool>.value(false);
    }
  }

  void _setListenToUserSessions() async {
    final _local = await LocalUser.getLocalUser();
    // _ref
    //     .child('users')
    //     .child(_local!.userAuth2)
    //     .child('assigned_sessions')
    //     .onValue
    //     .listen((event) async {
    //   for (DataSnapshot _snapshot in event.snapshot.children) {
    //     final String _sessionKey = _snapshot.value.toString();
    //     _sessions.add(_sessionKey);
    //   }
    //   setState(() {
    //     _sessions;
    //     _local.addSessionToList(_sessions);
    //   });
    // });
  }

  @override
  void initState() {
    _isManager();
    _setListenToUserSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onTapped(int index) {
      setState(() {
        pControll.animateToPage(index,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      });
    }

    void _onPageChanged(int index) {
      setState(() {
        _selected = index;
      });
    }

    return Scaffold(
      body: Center(
        child: PageView(
          controller: pControll,
          onPageChanged: _onPageChanged,
          pageSnapping: true,
          children: isManager
              ? const [
                  Home(),
                  MyCourses(),
                  Store(),
                  Settings(),
                  Admin(),
                ]
              : const [
                  Home(),
                  MyCourses(),
                  Store(),
                  Settings(),
                ],
        ),
      ),
      bottomSheet: BottomNavigationBar(
        currentIndex: _selected,
        items: isManager ? manager : standard,
        showSelectedLabels: true,
        selectedItemColor: Colors.greenAccent,
        onTap: _onTapped,
      ),
    );
  }
}


const List<BottomNavigationBarItem> standard = [
      BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), label: 'Home'),
  BottomNavigationBarItem(
      icon: Icon(Icons.my_library_add_outlined), label: 'Courses'),
      BottomNavigationBarItem(
          icon: Icon(Icons.shop_outlined), label: 'Store'),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined), label: 'Settings'),
    ];

const List<BottomNavigationBarItem> manager = [
  BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined), label: 'Home'),
  BottomNavigationBarItem(
      icon: Icon(Icons.my_library_add_outlined), label: 'Courses'),
  BottomNavigationBarItem(
      icon: Icon(Icons.shop_outlined), label: 'Store'),
  BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined), label: 'Settings'),
  BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin'),
];