import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:flutter/material.dart';

class Session{
  final String _sessionName;
  final String _desc;
  final String _videoUrl;
  final List<Exercise> _exercises;

  Session(this._sessionName, this._desc,this._exercises, this._videoUrl);


  String get desc => _desc;
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => Session00(session: _session,)));
        },
        title: Text(_session.sessionName),
        trailing: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}