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

  Future<void> _isManager() async {
      final _localUser = await LocalUser.getLocalUser();
    if (_localUser != null) {
      UserCredential _usercred = await _auth.signInWithEmailAndPassword(
          email: _localUser.email, password: _localUser.password);
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
    } else {
      LocalUser.signInAno();
    }
  }

  Future<void> hasAccount() async {}

  @override
  void initState() {
    _isManager();
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
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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