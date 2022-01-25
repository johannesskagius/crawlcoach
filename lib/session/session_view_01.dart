import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class Session01 extends StatefulWidget {
  const Session01({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  State<Session01> createState() => _Session01State();
}

class _Session01State extends State<Session01> {
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;

  @override
  void initState() {
    //_controller = VideoPlayerController.asset('assets/videos/crawl_intro.mp4');
    _controller = VideoPlayerController.network(widget.session.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}