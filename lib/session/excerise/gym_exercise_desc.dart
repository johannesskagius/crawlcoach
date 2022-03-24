import 'package:crawl_course_3/session/excerise/gym_exercise.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GymExerciseDesc extends StatefulWidget {
  const GymExerciseDesc({Key? key, required this.exercise}) : super(key: key);
  final GymExercise exercise;

  @override
  State<GymExerciseDesc> createState() => _GymExerciseDescState();
}

class _GymExerciseDescState extends State<GymExerciseDesc> {
  String _videoID = '';
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;
  bool _showGif = false;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    String? _vidUrl = widget.exercise.gifUrl;
    if (_vidUrl.isNotEmpty) {
      _showGif = true;
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
          title: Text(widget.exercise.name),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _content(
                _controller, _showGif, _height, _width, widget.exercise),
          ),
        ));
  }
}

List<Widget> _content(YoutubePlayerController? _controller, bool _showVideo,
    double _height, double _width, GymExercise _ex) {
  List<Widget> _list = [];
  if (_showVideo) {
    _list.add(SizedBox(
      height: _height * 0.5,
      child: Image.network(_ex.gifUrl),
    ));
  }
  _list.addAll([
    SizedBox(
      height: _height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(_ex.target)],
      ),
    ),
  ]);
  return _list;
}
