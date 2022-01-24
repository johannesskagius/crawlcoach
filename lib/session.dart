import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Session extends StatefulWidget {
  Session({Key? key}) : super(key: key);

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final PageController pControll = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('swim session'),
      ),
      body: PageView(
        pageSnapping: true,
        controller: pControll,
        children: [
          Session01(_height, _width),
          Session02(_height, _width),
        ],
      ),
      //bottomSheet: TODO att progressindicator,
    );
  }
}

class Session01 extends StatefulWidget {
  const Session01(double height, double width, {Key? key}) : super(key: key);

  @override
  State<Session01> createState() => _Session01State();
}

class _Session01State extends State<Session01> {
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _controller;

  @override
  void initState() {
    //_controller = VideoPlayerController.asset('assets/videos/crawl_intro.mp4');
    _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
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

class Session02 extends StatelessWidget {
  const Session02(this._height, this._width, {Key? key}) : super(key: key);
  final double _height;
  final double _width;
  final String _heading = 'Streamline 01';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: _height / 10,
            child: Text(_heading),
          ),
          SizedBox(
            height: _height / 10,
          )
        ],
      ),
    );
  }
}

class SessionPreview extends StatelessWidget {
  const SessionPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
