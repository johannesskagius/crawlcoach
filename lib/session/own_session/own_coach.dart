import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../account/user2.dart';
import 'free_session.dart';
import 'my_session.dart';

class OwnCoach extends StatefulWidget {
  const OwnCoach({Key? key}) : super(key: key);

  @override
  _OwnCoachState createState() => _OwnCoachState();
}

class _OwnCoachState extends State<OwnCoach> {
  List<Card> _cards = [];
  List<Session> _completed = [];

  void _getCompleted() async {
    List<Card> _courses = [];
    final _user = await User2.getLocalUser();
    DataSnapshot _data =
        await User2.ref.child(_user!.userAuth).child('c_courses').get();
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

  @override
  void initState() {
    _getCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MySessions()));
              },
              icon: const Icon(Icons.save_outlined)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin: const EdgeInsets.all(8),
                //Show training calendar
                child: Card(
                  elevation: 8,
                  child: ListTile(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FreeSession()));
                    },
                    title: const Text('Start session'),
                  ),
                )),
            const Divider(
              height: 1,
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
            )
          ],
        ),
      ),
    );
  }
}