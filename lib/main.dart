import 'dart:convert';

import 'package:crawl_course_3/session/excerise/current_exercises.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:crawl_course_3/settings.dart';
import 'package:crawl_course_3/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
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
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
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

  int _selected = 0;

  Future<LocalUser> getLocalUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap =
          jsonDecode(sharedPreferences.getString('USER_CRED')!);
      LocalUser _localUser = LocalUser.fromJson(userMap);
      return _localUser;
    } catch (exception) {
      return LocalUser('', '', '', '');
    }
  }

  @override
  void initState() {
    getLocalUser();
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

    return FutureBuilder<LocalUser>(
      future: getLocalUser(),
      builder: (BuildContext context, AsyncSnapshot<LocalUser> snapshot) {
        List<Widget> childs;
        if (snapshot.hasData) {
          childs = <Widget>[
            Home(snapshot.data!.firstName),
            const About(),
            const Settings(),
          ];
        } else {
          childs = <Widget>[const Home('unkown'), const About(), const Settings()];
        }
        return Scaffold(
            appBar: AppBar(
              title: const Text('Crawl Coach'),
            ),
            body: Center(
              child: PageView(
                controller: pControll,
                pageSnapping: true,
                children: childs,
                onPageChanged: _onPageChanged,
              ),
            ),
            bottomSheet: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.run_circle_outlined), label: 'Swim'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings_outlined), label: 'Settings'),
                ],
                currentIndex: _selected,
                showSelectedLabels: true,
                selectedItemColor: Colors.greenAccent,
                onTap: _onTapped));
      },
    );
  }
}