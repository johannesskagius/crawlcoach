import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Session {
  final String _sessionName;
  final String _desc;
  final String _videoUrl;
  final List<dynamic> _exercises;

  Session(this._sessionName, this._desc, this._exercises, this._videoUrl);

  Map<String, dynamic> toJson() => {
        'title': _sessionName,
        'subTitle': _desc,
        'video_url': '',
        'exercises': _exercises,
      };

  factory Session.fromJson(dynamic json) => _sessionFromJson(json);

  String get desc => _desc;
  String get sessionName => _sessionName;
  List<dynamic> get exercises => _exercises;
  String get videoUrl => _videoUrl;

  static Future<Session> getSession() async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    LocalUser? _x = await LocalUser.getLocalUser();
    print(_x!.userAuth2);
    try {
      DataSnapshot x = await _ref
          .child('users')
          .child(_x.userAuth2)
          .child('intro_sessions')
          .get();
      print(x.toString());
      if (x.value == "false") {
        print('here');
      }
    } catch (e) {
      print(e);
    }
    throw NullThrownError();
  }

  Future<void> pushSessionStats(List<double> stats, String s, String userID) async {
    final DatabaseReference _ref = FirebaseDatabase.instance.ref();
    await _ref.child('session_stats').child(s).child(userID).set(stats.toString());
  }

  @override
  String toString() {
    return 'Session{_sessionName: $_sessionName, _desc: $_desc}';
  }
}


Session _sessionFromJson(dynamic json) {
  return Session(json['title'] as String, json['subTitle'] as String,
      json['exercises'] as List<dynamic>, json['subTitle'] as String);
}

class SessionPreview extends StatelessWidget {
  const SessionPreview(this._session, {Key? key}) : super(key: key);
  final Session _session;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Session00(
                        session: _session,
                      )));
        },
        title: Text(_session.sessionName),
        trailing: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
