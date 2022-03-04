import 'package:crawl_course_3/account/user2.dart';
import 'package:flutter/material.dart';

import 'user_profile.dart';

class UserSettings extends StatefulWidget {
  const UserSettings(this._user, {Key? key}) : super(key: key);
  final User2 _user;

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String nrOfCourses = '';

  void getNrOfSessions() async {
    String s = await widget._user.getNrOfAssignedCourses();
    setState(() {
      nrOfCourses = s;
    });
  }

  @override
  void initState() {
    getNrOfSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateUser(widget._user))),
            child: Container(
              color: Colors.transparent,
              child: UserEmail(false, widget._user),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                User2.logOutUser();
              },
              child: const Text('Sign out')),
        ],
      ),
    );
  }
}

