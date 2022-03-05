import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'account/user2.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final asset = 'assets/videos/IMG_4498_HD.mp4';
  List<SessionPreview> _previews = [];
  VideoPlayerController? controller;

  void setPreviews2(Map<String, List<String>> listOfSessions) async {
    List<SessionPreview> nextInAssigned = [];
    for (String session in listOfSessions.keys) {
      String sName = listOfSessions[session]!.elementAt(0);
      String sId = listOfSessions[session]!.elementAt(1);
      final data = await Session.sessionRef.child(sId).child(sName).get();
      nextInAssigned.add(SessionPreview(Session.fromJson(data.value)));
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
                    'Today is your opportunity to build the tomorrow you',
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
    final _ref = User2.ref.child(_local!.userAuth).child('a_sessions');
    DataSnapshot _data = await _ref.get();
    Map<String, List<String>> _nextInAssCourse = {};
    for (DataSnapshot assignedCourse in _data.children) {
      List<String> list = [];
      list.add(assignedCourse.child('session').children.first.key.toString());
      list.add(assignedCourse.child('userID').value.toString());
      _nextInAssCourse[assignedCourse.key.toString()] = list;
    }
    setPreviews2(_nextInAssCourse);
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
