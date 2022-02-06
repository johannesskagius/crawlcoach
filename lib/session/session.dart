import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Session {
  static final DatabaseReference _sessionRef =
      FirebaseDatabase.instance.ref().child('courses');
  final String sessionName;
  final String desc;
  final String videoUrl;
  final List<Object?> exercises;

  Session(
      {required this.sessionName,
      required this.desc,
      required this.exercises,
      required this.videoUrl});

  Map<String, dynamic> toJson() => {
    'title': sessionName,
    'subTitle': desc,
    'video_url': '',
    'exercises': exercises,
  };

  factory Session.fromJson(dynamic json) => _sessionFromJson(json);

  static Future<Session> getSession() async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    LocalUser? _x = await LocalUser.getLocalUser();
    try {
      DataSnapshot x = await _ref
          .child('users')
          .child(_x!.userAuth2)
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
    await _ref
        .child('session_stats')
        .child(s)
        .child(userID)
        .set(stats.toString());
  }

  static void getSessionStats() async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    DataSnapshot _snap = await _ref.child('session_stats').get();
    for (DataSnapshot _data in _snap.children) {
      print(_data.value.toString());
    }
  }

  @override
  String toString() {
    return 'Session{_sessionName: $sessionName, _desc: $desc}';
  }
}

Session _sessionFromJson(dynamic json) {
  return Session(
      sessionName: json['title'],
      desc: json['subTitle'],
      exercises: json['exercises'],
      videoUrl: '');
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
