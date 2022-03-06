import 'package:crawl_course_3/account/user2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'user_profile.dart';

class UserSettings extends StatefulWidget {
  const UserSettings(this._user, {Key? key}) : super(key: key);
  final User2 _user;

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  List<Card> _cards = [];

  @override
  void initState() {
    _getCompleted();
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
          SizedBox(
            height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height) *
                0.4,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _cards.length,
              itemBuilder: (BuildContext context, int index) {
                return _cards.elementAt(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _getCompleted() async {
    List<Card> _courses = [];
    DataSnapshot _data =
        await User2.ref.child(widget._user.userAuth).child('c_courses').get();
    for (DataSnapshot _d in _data.children) {
      _courses.add(Card(
        child: ListTile(
          title: Text(_d.key.toString()),
          trailing: const Icon(Icons.navigate_next_outlined),
        ),
      ));
    }
    setState(() {
      _cards = _courses;
    });
  }
}
