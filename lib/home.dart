import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Session _nextSession = Session(
      desc: 'Loading', videoUrl: '', sessionName: 'Loading', exercises: []);
  final asset = 'assets/videos/IMG_4498_HD.mp4';
  List<Container> _previews = [];
  VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crawl Coach'),
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

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //_coursesAssigned();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play())
      ..setVolume(0);
  }
}

Future<List<Container>> _coursesAssigned() async {
  final _local = await LocalUser.getLocalUser();
  final _userRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(_local!.userAuth2)
      .child('assigned_sessions');
  final _sessionRef = FirebaseDatabase.instance.ref().child('sessions');
  final _courseRef = FirebaseDatabase.instance.ref().child('courses');
  List<Container> nextInAssigned = [];
  List<String> _courseNames = [];

  //Get assigned courses,
  // DataSnapshot _assigned = await _userRef.get();
  // for(DataSnapshot _courseName in _assigned.children){
  //     if(!_courseNames.contains(_courseName.toString())){
  //       _courseNames.add(_courseName.key.toString());
  //     }
  // }
  //print(_courseNames);

  // //Get first session in assigned course
  // List<Session> _sessions = [];
  // for(String _sessionKey in _courseNames){
  //   DataSnapshot _sessionSnap = await _courseRef.child(_sessionKey).get();
  //
  //   //final _session = Session.fromJson(_sessionSnap);
  //   //print(_sessionSnap.value.toString());
  // }

  return nextInAssigned;
}
