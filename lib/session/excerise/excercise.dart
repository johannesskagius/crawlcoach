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
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    if (widget.exercise.url != null) {
      //_videoID = YoutubePlayer.convertUrlToId(widget.exercise.url.toString())!;
      _videoID = YoutubePlayer.convertUrlToId(
          'https://www.youtube.com/watch?v=IkDAb4hlof0')!;
    }
    _controller = YoutubePlayerController(initialVideoId: _videoID);
    _controller.setVolume(30);
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
            children: <Widget>[
              SizedBox(
                height: _height * 0.3,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.greenAccent,
                ),
              ), //TODO show video of excercise,
              SizedBox(
                height: _height * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.exercise.perk1),
                    Text(widget.exercise.perk2),
                    Text(widget.exercise.perk3)
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: widget.exercise.description.length,
                itemBuilder: (BuildContext context, int index) {
                  return Explained(
                    number: index.toString(),
                    description:
                        widget.exercise.description.elementAt(index).toString(),
                    width: _width,
                  );
                },
              ))
            ],
          ),
        ));
  }
}
