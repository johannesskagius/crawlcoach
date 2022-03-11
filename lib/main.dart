import 'dart:async';

import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/excerise/view_exercises.dart';
import 'package:crawl_course_3/settings2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'account/my_courses.dart';
import 'admin/add_exercises_admin.dart';
import 'admin/add_session/add_session.dart';
import 'admin/add_session/view_sessions.dart';
import 'admin/admin.dart';
import 'courses/add_offer.dart';
import 'courses/view_offers.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
        overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      routes: {
        '/addsession': (context) => const AddSession(),
        '/viewSessions': (context) => const ViewSessions(),
        '/addoffer': (context) => const AddOffer(),
        '/viewOffers': (context) => const ViewOffers(),
        '/addexercise': (context) => const AddExercise(),
        '/viewexercises': (context) => const ViewExercises(),
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
  final PageController pControl = PageController();
  bool isManager = false;
  int _selected = 0;

  Future<void> _checkIfManager() async {
    User2? user = await User2.getLocalUser();
    bool _manager = false;
    if (User2.firebaseAuth.currentUser!.isAnonymous) {
      return;
    }
    FirebaseDatabase.instance
        .ref()
        .child('admins')
        .child(user!.userAuth)
        .onValue
        .listen((event) {
      if (event.snapshot.child('isadmin').value.toString() == 'true') {
        _manager = true;
      } else {
        _manager = false;
      }
      setState(() {
        isManager = _manager;
      });
    });
  }

  @override
  void initState() {
    _checkIfManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onTapped(int index) {
      setState(() {
        pControl.animateToPage(index,
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
          controller: pControl,
          onPageChanged: _onPageChanged,
          pageSnapping: true,
          children: isManager
              ? const [
                  Home(),
                  MyCourses(),
                  Store2(),
                  Settings2(),
                  Admin(),
                ]
              : const [
                  Home(),
                  MyCourses(),
                  Store2(),
                  Settings2(),
                ],
        ),
      ),
      bottomSheet: BottomNavigationBar(
        currentIndex: _selected,
        items: isManager ? manager : standard,
        showSelectedLabels: true,
        selectedItemColor: Colors.greenAccent,
        onTap: onTapped,
      ),
    );
  }
}

const List<BottomNavigationBarItem> standard = [
  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
  BottomNavigationBarItem(
      icon: Icon(Icons.my_library_add_outlined), label: 'Courses'),
  BottomNavigationBarItem(icon: Icon(Icons.shop_outlined), label: 'Store'),
  BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined), label: 'Settings'),
];

const List<BottomNavigationBarItem> manager = [
  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
  BottomNavigationBarItem(
      icon: Icon(Icons.my_library_add_outlined), label: 'Courses'),
  BottomNavigationBarItem(icon: Icon(Icons.shop_outlined), label: 'Store'),
  BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined), label: 'Settings'),
  BottomNavigationBarItem(
      icon: Icon(Icons.admin_panel_settings_outlined), label: 'Admin'),
];
