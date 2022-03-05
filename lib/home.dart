import 'dart:async';

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
  late StreamSubscription _sub;

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

  Future<void> _listenToAssigned() async {
    final _local = await User2.getLocalUser();
    final _ref = User2.ref.child(_local!.userAuth).child('a_sessions');
    Map<String, List<String>> _nextInAssCourse = {};
    List<SessionPreview> nextInAssigned = [];
    _sub = _ref.onValue.listen((event) async {
      for (DataSnapshot _data in event.snapshot.children) {
        List<String> list = [];
        list.add(_data.child('session').children.first.key.toString());
        list.add(_data.child('userID').value.toString());
        list.add(_data.key.toString());
        _nextInAssCourse[_data.key.toString()] = list;
      }

      for (String session in _nextInAssCourse.keys) {
        String _sName = _nextInAssCourse[session]!.elementAt(0);
        String _sId = _nextInAssCourse[session]!.elementAt(1);
        String _course = _nextInAssCourse[session]!.elementAt(2);
        final data = await Session.sessionRef.child(_sId).child(_sName).get();
        nextInAssigned
            .add(SessionPreview(Session.fromJson(data.value), _course));
      }
      setState(() {
        _previews = nextInAssigned;
      });
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    _sub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listenToAssigned();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play())
      ..setVolume(0);
  }
}
