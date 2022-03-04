import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

class Session04 extends StatefulWidget {
  const Session04(this._session, this._sessionID, {Key? key}) : super(key: key);
  final Session _session;
  final String _sessionID;

  @override
  State<Session04> createState() => _Session04State();
}

class _Session04State extends State<Session04> {
  bool isDone = false;
  double _sessionFun = 0;
  double _sessionClearity = 0;
  double _sessionToughness = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: _height,
      width: _width,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text('How fun was the session?'),
            Slider(
                label: "$_sessionFun",
                divisions: 10,
                max: 10,
                min: 0,
                value: _sessionFun,
                onChanged: (val) {
                  setState(() {
                    _sessionFun = val;
                  });
                }),
            const Text('Where the instructions clear'),
            Slider(
                label: "$_sessionClearity",
                divisions: 10,
                max: 10,
                min: 0,
                value: _sessionClearity,
                onChanged: (val) {
                  setState(() {
                    _sessionClearity = val;
                  });
                }),
            const Text('Was the session though?'),
            Slider(
                label: "$_sessionToughness",
                divisions: 10,
                max: 10,
                min: 0,
                value: _sessionToughness,
                onChanged: (val) {
                  setState(() {
                    _sessionToughness = val;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Did you do the session?',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Switch(
                  value: isDone,
                  onChanged: (value) async {
                    setState(() {
                      isDone = value;
                    });
                    //Move session to done sessions
                    final user = await User2.getLocalUser();
                    user!.markSessionDone(widget._sessionID, widget._session);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
