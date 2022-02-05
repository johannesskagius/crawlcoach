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
                Container(
                    alignment: Alignment.bottomCenter,
                    child: SessionPreview(_nextSession))
              ],
            ),
          ],
        )));
  }

  void getEntrySessionsKies() async {
    List<String> _startingSessions = [];
    LocalUser? _local = await LocalUser.getLocalUser();
    List<String> _completed = await _local!.completedSession();

    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    _ref
        .child('users')
        .child(_local.userAuth2)
        .child('assigned_sessions')
        .onValue
        .listen((event) async {
      for (DataSnapshot _snap in event.snapshot.children) {
        final String _session = _snap.value.toString();
        //Check if user already done session
        if (!_completed.contains(_session)) {
          // && !_doneSessions.contains(_session)
          _startingSessions.add(_session);
        }
      }
      DataSnapshot x = await _ref
          .child('sessions')
          .child(_startingSessions.elementAt(0))
          .get();
      setState(() {
        try{
          _nextSession = Session.fromJson(x.value);
        }catch(e){
         print('home: $e');
        }
      });
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //getEntrySessionsKies();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play())
    ..setVolume(0);
  }
}
