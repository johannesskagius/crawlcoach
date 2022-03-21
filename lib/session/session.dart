import 'package:crawl_course_3/account/user2.dart';
import 'package:crawl_course_3/session/session_view_00.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Session {
  static final DatabaseReference sessionRef =
      FirebaseDatabase.instance.ref().child('sessions');
  String? time;
  final String sessionName;
  final String desc;
  final String videoUrl;
  final Map<Object?, Object?> exercises;

  Session(this.time,
      {required this.sessionName,
      required this.desc,
      required this.exercises,
      required this.videoUrl});

  Map<String, dynamic> toJson() => {
        'title': sessionName,
        'subTitle': desc,
        'video_url': '',
        'exercises': exercises,
        'time': time,
      };

  factory Session.fromJson(dynamic json) => _sessionFromJson(json);

  Future<void> pushSessionFeedback(Map<String, double> _sessionStats,
      String _sessionName, String _uID) async {
    final DatabaseReference _ref = FirebaseDatabase.instance.ref();
    await _ref
        .child('session_stats')
        .child(_sessionName)
        .child(_uID)
        .set(_sessionStats);
  }

  @override
  String toString() {
    return 'Session{_sessionName: $sessionName, _desc: $desc}';
  }

  Table previewTable(double _width, double _height) {
    const double headerSize = 18;
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(_width * 0.35),
        1: const FlexColumnWidth(),
      },
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: <Widget>[
          const TableCell(
              child: Text(
            'Name:',
            style: TextStyle(fontSize: headerSize, fontWeight: FontWeight.bold),
          )),
          TableCell(child: Text(sessionName)),
        ]),
        TableRow(children: <Widget>[
          const TableCell(
              child: Text('Nr of exercises:',
                  style: TextStyle(
                      fontSize: headerSize, fontWeight: FontWeight.bold))),
          TableCell(
            child: Text(exercises.keys.length.toString()),
          ),
        ]),
        TableRow(children: <Widget>[
          const TableCell(
              child: Text('Description:',
                  style: TextStyle(
                      fontSize: headerSize, fontWeight: FontWeight.bold))),
          TableCell(child: Text(desc)),
        ]),
      ],
    );
  }
}

Session _sessionFromJson(dynamic json) {
  return Session(
      json['time'],
      sessionName: json['title'],
      desc: json['subTitle'],
      exercises: json['exercises'],
      videoUrl: '');
}

class SessionPreview extends StatelessWidget {
  const SessionPreview(this._session, this._offerName, {Key? key})
      : super(key: key);
  final Session _session;
  final String _offerName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.grey.withOpacity(0.5),
      child: ListTile(
        onTap: () async {
          final user = await User2.getLocalUser();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Session00(
                        session: _session,
                        id: user!.userAuth,
                        offerName: _offerName,
                      )));
        },
        title: Text(_session.sessionName),
        trailing: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}

class SessionPreviewNoSession extends StatelessWidget {
  const SessionPreviewNoSession(
      this._sessionName, this._sessionKey, this._offerName,
      {Key? key})
      : super(key: key);
  final String _sessionName;
  final String _sessionKey;
  final String _offerName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () async {
          DataSnapshot _snap = await Session.sessionRef
              .child(_sessionKey)
              .child(_sessionName)
              .get();
          Session session = Session.fromJson(_snap.value);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Session00(
                    session: session,
                    id: _sessionKey,
                    offerName: _offerName,
                  )));
        },
        title: Text(
          _sessionName,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        trailing: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}