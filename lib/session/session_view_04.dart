import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Session04 extends StatefulWidget {
  const Session04({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  State<Session04> createState() => _Session04State();
}

class _Session04State extends State<Session04> {
  bool isDone = false;
  double _sessionFun = 0;
  double _sessionClearity = 0;
  double _toughness = 0;

  @override
  Widget build(BuildContext context) {

    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    Future<void> incrementSessionsDone() async{
      const String SESSIONS_DONE = 'sessions_done';
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      int nrSessions = sharedPreferences.getInt('SESSIONS_DONE') ?? 0;
      sharedPreferences.setInt(SESSIONS_DONE, nrSessions++);
    }

    return SizedBox(
      height: _height,
      width: _width,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text('How fun was the session?'),
            Slider(label: "$_sessionFun" ,divisions: 10, max: 10, min: 0,value: _sessionFun, onChanged: (val){
              setState(() {
                _sessionFun = val;
              });
            }),
            const Text('Where the instructions clear'),
            Slider(label: "$_sessionClearity" ,divisions: 10, max: 10, min: 0,value: _sessionClearity, onChanged: (val){
              setState(() {
                _sessionClearity = val;
              });
            }),
            const Text('Was the session though?'),
            Slider(label: "$_toughness" ,divisions: 10, max: 10, min: 0,value: _toughness, onChanged: (val){
              setState(() {
                _toughness = val;
              });
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Did you do the session?', style: TextStyle(
                  fontSize: 24,
                ),),
                Switch(value: isDone, onChanged: (value){
                  setState(() {
                    isDone = value;
                  });
                  //Mark sessions as done,
                  incrementSessionsDone();
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
