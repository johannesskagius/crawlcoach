import 'dart:convert';

import 'package:crawl_course_3/account/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account/user_settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late LocalUser _localUser;
  late String userJson;

  Future<bool> _gotAUser() async{
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('GOT_USER') ?? false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const UserSettings(),
    );
  }
}


