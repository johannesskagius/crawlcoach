import 'package:crawl_course_3/account/user2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'user_profile.dart';

class UserSettings extends StatefulWidget {
  const UserSettings(this._user, {Key? key}) : super(key: key);
  final User2 _user;

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'user',
            style: TextStyle(
              fontWeight: FontWeight.w100,
            ),
          ),
          Material(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                border: _border(),
              ),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateUser(widget._user))),
                child: Container(
                  color: Colors.transparent,
                  child: UserEmail(false, widget._user),
                ),
              ),
            ),
          ),
          const Divider(
            height: 16,
          ),
        ],
      ),
    );
  }
}

Border _border() {
  return Border.all(color: Colors.black12, width: 1);
}
