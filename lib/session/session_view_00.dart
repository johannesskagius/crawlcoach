import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/session/session_view_01.dart';
import 'package:crawl_course_3/session/session_view_02.dart';
import 'package:crawl_course_3/session/session_view_04.dart';
import 'package:flutter/material.dart';

class Session00 extends StatefulWidget {
  const Session00(
      {Key? key,
      required this.session,
      required this.id,
      required this.offerName})
      : super(key: key);
  final Session session;
  final String id;
  final String offerName;

  @override
  State<Session00> createState() => _Session00State();
}

class _Session00State extends State<Session00> {
  String _subTitle = 'video';
  int _selected = 0;
  bool _showVideo = false;

  @override
  void initState() {
    String s = widget.session.videoUrl;
    if (s.isNotEmpty) {
      _showVideo = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pControll = PageController();
    String _title = widget.session.sessionName;
    void _changeTitle(int index) {
      setState(() {
        _selected = index;
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
        children: _showVideo
            ? _listWVideo(widget.session, widget.id, widget.offerName)
            : _listWOVideo(widget.session, widget.id, widget.offerName),
        onPageChanged: (value) {
          _changeTitle(value);
        },
      ),
      bottomSheet: BottomNavigationBar(
        currentIndex: _selected,
        items: _showVideo ? _bottomWVideo() : _bottomWOVideo(),
        showSelectedLabels: true,
        selectedItemColor: Colors.greenAccent,
      ),
    );
  }
}

List<BottomNavigationBarItem> _bottomWOVideo() {
  return <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(Icons.check_outlined), label: 'Exercises'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.check_outlined), label: 'Completed'),
  ];
}

List<BottomNavigationBarItem> _bottomWVideo() {
  return <BottomNavigationBarItem>[
    const BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Video'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.check_outlined), label: 'Exercises'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.check_outlined), label: 'Completed'),
  ];
}

List<Widget> _listWVideo(Session _session, String _id, String _offerName) {
  return <Widget>[
    Session01(_session), //Video
    Session02(_session, _id), //Exercises as list,
    Session04(_session, _id, _offerName),
  ];
}

List<Widget> _listWOVideo(Session _session, String _id, String _offerName) {
  return <Widget>[
    Session02(_session, _id), //Exercises as list,
    Session04(_session, _id, _offerName),
  ];
}