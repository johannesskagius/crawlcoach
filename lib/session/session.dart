import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:flutter/material.dart';

class Session{
  final String _sessionName;
  final String _videoUrl;
  final List<Exercise> _exercises;

  Session(this._sessionName, this._exercises, this._videoUrl);

  Duration getTime(){
    Duration sessionDuration = const Duration(minutes: 0);
    for(Exercise x in _exercises){
      sessionDuration += x.timeToFinish;
    }
    return sessionDuration;
  }
  String get sessionName => _sessionName;

  List<Exercise> get exercises => _exercises;

  String get videoUrl => _videoUrl;
}

class SessionPreview extends StatelessWidget {
  const SessionPreview(this._session, {Key? key}) : super(key: key);
  final Session _session;
    
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (){
          Navigator.pushNamed(context, '/session');
        },
        leading: Text(_session.getTime().inMinutes.toString() + ' min'),
        title: Text(_session.sessionName),
        trailing: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}