import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';

class Session04 extends StatefulWidget {
  const Session04(this._session, {Key? key}) : super(key: key);
  final Session _session;

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

  Future<LocalUser?> _getLocal() async {
    return await LocalUser.getLocalUser();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: _getLocal(),
        builder: (BuildContext context, AsyncSnapshot<LocalUser?> snapshot) {
          Switch _switch;
          if (snapshot.hasData && snapshot.data != null) {
            _switch = Switch(
                value: isDone,
                onChanged: (value) {
                  setState(() {
                    isDone = value;
                  });
                  //Mark sessions as done,
                  snapshot.requireData!.markSessionAsDone(widget._session.sessionName);
                  //Upload stats to server,
                  List<double> _stats =[_sessionFun, _sessionClearity, _sessionToughness];
                  widget._session.pushSessionStats(_stats, widget._session.sessionName, snapshot.requireData!.userAuth2);
                  Navigator.pop(context);
                });
          }else{
            _switch = Switch(value: isDone, onChanged: (value){
              setState(() {
                isDone = value;
              });
              Navigator.pop(context);
            });
          }
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
                      _switch,
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
