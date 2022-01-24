import 'package:crawl_coach/session.dart';
import 'package:crawl_coach/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
import 'ftime.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



Future<bool?> _checkFirstTime() async {
  final _prefs = await SharedPreferences.getInstance();
  const String KEY = 'firstTime';
  _prefs.setBool('KEY', false);
  print(_prefs.getBool('KEY'));
  return _prefs.getBool('KEY');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) {
          return const Home();
        },
        '/about': (BuildContext context) {
          return const About();
        },
        '/session': (BuildContext context) {
          return Session();
        },
        '/settings': (BuildContext context) {
          return const Settings();
        },
      },
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: Layout(),
    );
  }
}

class Layout extends StatefulWidget {
  Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final PageController pControll = PageController();

  @override
  Widget build(BuildContext context) {
    void _goTo(String s) {
      Navigator.pushNamed(context, s);
    }

    int _selected = 0;
    void _onTapped(int index){
      setState(() {
        pControll.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.fastLinearToSlowEaseIn);
      });
    }

    void _onPageChanged(int index){
        setState(() {
          _selected = index;
        });
    }

    return Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Crawl coach'),
            ),
            body: Center(
              child: PageView(
                pageSnapping: true,
                controller: pControll,
                children: const <Widget>[
                  Home(),
                  About(),
                  Settings(),
                ],
                onPageChanged: (page){_onPageChanged(page);},
              ),
            ),
          bottomSheet: BottomNavigationBar(items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.run_circle_outlined), label: 'Swim'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
              currentIndex: _selected,
              showSelectedLabels: true,
              selectedItemColor: Colors.greenAccent,
              onTap: _onTapped)
        ));
  }
}

/*
ElevatedButton(
            onPressed: () {
                Navigator.pushNamed(context, '/about');
            },
            child: Text('Go to About'),
          ),
*
* */
