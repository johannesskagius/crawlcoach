import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class Session01 extends StatefulWidget {
  const Session01(this._session, {Key? key}) : super(key: key);
  final Session _session;

  @override
  State<Session01> createState() => _Session01State();
}

class _Session01State extends State<Session01> {
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget._session.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('error');
            case ConnectionState.waiting:
              return const Text('waiting');
            case ConnectionState.active:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              );
          }
        });
  }
}