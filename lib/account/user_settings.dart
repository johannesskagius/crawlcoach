import 'package:crawl_course_3/account/user2.dart';
import 'package:firebase_database/firebase_database.dart';
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
          Material(
            elevation: 8,
            child: Container(
              child: _cards.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Completed courses',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _cards.elementAt(index);
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: _border(),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: const [
                          ListTile(
                            title: Text(
                                'Your completed courses will be saved here',
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                )),
                          )
                        ],
                      ),
                    ),
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

Border _border() {
  return Border.all(color: Colors.black12, width: 1);
}
