import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/session/session_view_01.dart';
import 'package:crawl_course_3/session/session_view_02.dart';
import 'package:crawl_course_3/session/session_view_04.dart';
import 'package:flutter/material.dart';

class Session00 extends StatefulWidget {
  const Session00({Key? key, required this.session, required this.id})
      : super(key: key);
  final Session session;
  final String id;

  @override
  State<Session00> createState() => _Session00State();
}

class _Session00State extends State<Session00> {
  String _subTitle = 'video';

  @override
  Widget build(BuildContext context) {
    final PageController pControll = PageController();
    String _title = widget.session.sessionName;
    void _changeTitle(int index) {
      setState(() {
        if (index == 0) {
          _subTitle = 'Swim session';
        } else if (index == 1) {
          _subTitle = 'Swim session description';
        } else {
          _subTitle = 'Overview';
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(children: [Text(_title), Text(_subTitle)]),
      ),
      body: PageView(
        pageSnapping: true,
        controller: pControll,
        children: [
          Session01(widget.session), //Video
          Session02(widget.session, widget.id), //Exercises as list,
          Session04(widget.session, widget.id), //
        ],
        onPageChanged: (value){
          _changeTitle(value);
        },
      ),
      //bottomSheet: TODO att progressindicator,
    );
  }
}


