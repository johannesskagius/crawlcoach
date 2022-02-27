import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'account/user2.dart';
import 'admin/courses/offer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final asset = 'assets/videos/IMG_4498_HD.mp4';
  List<SessionPreview> _previews = [];
  VideoPlayerController? controller;

  void setPreviews(List<Session> listOfSessions) {
    List<SessionPreview> nextInAssigned = [];
    for (Session session in listOfSessions) {
      nextInAssigned.add(SessionPreview(session));
    }
    setState(() {
      _previews = nextInAssigned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '21th Swim',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        body: Center(
            child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              child: controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: VideoPlayer(controller!),
                    )
                  : const CircularProgressIndicator(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Today is your opportunity to build the tomorrow you want',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Column(
                  children: _previews,
                ),
              ],
            ),
          ],
        )));
  }

  Future<void> _coursesAssigned() async {
    final _local = await User2.getLocalUser();
    if (_local != null) {
      final _userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(_local.userAuth)
          .child('assigned_sessions');

      List<String> _courseNames = [];
//  Get assigned courses,
      DataSnapshot _assigned = await _userRef.get();
      for (DataSnapshot _courseName in _assigned.children) {
        if (!_courseNames.contains(_courseName.toString())) {
          _courseNames.add(_courseName.key.toString());
        }
      }
      //Get first sessions in assigned course
      List<Object?> _sessionKeys = [];
      for (Object _sessionKey in _courseNames) {
        DataSnapshot _sessionSnap = await Offer.courseRef
            .child(_sessionKey.toString())
            .child('session')
            .get();
        for (DataSnapshot _snapshot in _sessionSnap.children) {
          if (!_sessionKeys.contains(_snapshot.toString())) {
            _sessionKeys.add(_snapshot.value);
            break;
          }
        }
      }

      //print(_sessionKeys);
      List<Session> _listOfSessions = [];
      for (Object? object in _sessionKeys) {
        DataSnapshot _sessionData =
            await Session.sessionRef.child(object.toString()).get();
        Session s = Session.fromJson(_sessionData.value);
        _listOfSessions.add(s);
      }
      setPreviews(_listOfSessions);
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _coursesAssigned();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play())
      ..setVolume(0);
  }
}

