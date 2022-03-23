import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseViewPort extends StatefulWidget {
  const ExerciseViewPort({Key? key, required this.exercise}) : super(key: key);
  final Exercise exercise;

  @override
  State<ExerciseViewPort> createState() => _ExerciseViewPortState();
}

class _ExerciseViewPortState extends State<ExerciseViewPort> {
  String _videoID = '';
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;
  bool _showVideo = false;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    String? _vidUrl = widget.exercise.url;
    if (_vidUrl != null && _vidUrl.isNotEmpty) {
      _videoID = YoutubePlayer.convertUrlToId(_vidUrl)!;
      _showVideo = true;
      _controller = YoutubePlayerController(initialVideoId: _videoID);
      _controller!.setVolume(30);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.title),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _content(
                _controller, _showVideo, _height, _width, widget.exercise),
          ),
        ));
  }
}

List<Widget> _content(YoutubePlayerController? _controller, bool _showVideo,
    double _height, double _width, Exercise _ex) {
  List<Widget> _list = [];
  if (_showVideo) {
    _list.add(_videoPlayer(_controller!, _height));
  }
  _list.addAll([
    SizedBox(
      height: _height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(_ex.perk1), Text(_ex.perk2), Text(_ex.perk3)],
      ),
    ),
    Expanded(
        child: ListView.builder(
      itemCount: _ex.description.length,
      itemBuilder: (BuildContext context, int index) {
        return Explained(
          number: index.toString(),
          description: _ex.description.elementAt(index).toString(),
          width: _width,
        );
      },
    ))
  ]);
  return _list;
}

Widget _videoPlayer(YoutubePlayerController _controller, double _height) {
  return SizedBox(
    height: _height * 0.3,
    child: YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.greenAccent,
    ),
  ); //TODO show video of excercise,
}