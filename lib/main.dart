import 'dart:async';
import 'dart:convert';

import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:crawl_course_3/settings.dart';
import 'package:crawl_course_3/account/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
import 'admin/add_exercises_admin.dart';
import 'admin/add_session/add_session.dart';
import 'admin/admin.dart';
import 'home.dart';

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
        '/addsession':(context)=>  const AddSession(),
        '/addexercise':(context)=>  const AddExercise(),
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

  int _selected = 0;

  Future<bool> _activateListener() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap =
        jsonDecode(sharedPreferences.getString('USER_CRED')!);
    LocalUser _local = LocalUser.fromJson(userMap);
    UserCredential _usercred = await _auth.signInWithEmailAndPassword(
        email: _local.email, password: _local.password);

    DataSnapshot tes = await _ref
        .child('users')
        .child(_usercred.user!.uid)
        .child('admin').get();

    if (tes.value.toString() == 'true') {
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onTapped(int index) {
      setState(() {
        pControll.animateToPage(index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastLinearToSlowEaseIn);
      });
    }

    void _onPageChanged(int index) {
      setState(() {
        _selected = index;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Crawl Coach'),
        ),
        body: Center(
          child: PageView(
            controller: pControll,
            pageSnapping: true,
            onPageChanged: _onPageChanged,
            children: const [
              Home(),
              About(),
              Settings(),
              First(),
            ],
          ),
        ),
        bottomSheet: FutureBuilder(
          future: _activateListener(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            List<BottomNavigationBarItem> _navigationList = [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.run_circle_outlined), label: 'Swim'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ];
            if (snapshot.hasData && snapshot.data == true) {
              _navigationList.add(const BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  label: 'Admin'));
            }
            return BottomNavigationBar(items: _navigationList,
                currentIndex: _selected,
                showSelectedLabels: true,
                selectedItemColor: Colors.greenAccent,
                onTap: _onTapped);
          },
        ));
  }
}

//BottomNavigationBar(
//                 items: const [

//                 ],

