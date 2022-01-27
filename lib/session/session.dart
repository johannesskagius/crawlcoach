import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Session{
  final String _sessionName;
  final String _desc;
  final String _videoUrl;
  final List<String> _exercises;

  Session(this._sessionName, this._desc,this._exercises, this._videoUrl);


  Map<String, dynamic> toJson() => {
    'title' : _sessionName,
    'subTitle': _desc,
    'video_url': '',
    'exercises': _exercises,
  };

  factory Session.fromJson(dynamic json) => _exerciseFromJson(json);


  String get desc => _desc;
  String get sessionName => _sessionName;
  List<String> get exercises => _exercises;
  String get videoUrl => _videoUrl;
}

Session _exerciseFromJson(dynamic json) {
  return Session(
      json['title'] as String,
      json['subTitle'] as String,
      json['exercises'] as List<String>,
      json['subTitle'] as String);
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