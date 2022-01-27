
import 'package:crawl_course_3/session/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session03 extends StatelessWidget {
  const Session03({Key? key, required this.session}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;
    //String? _sessionsDone = await getSessionsDone();

    return SizedBox(
        height: _height,
        width: _width,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SessionAttributes('Exercises: ', session.exercises.length.toString(), _width,),
              //SessionAttributes('Time: ', session.getTime().inMinutes.toString() +' minutes', _width,),
              //SessionAttributes('Number of exercises: ', session.exercises.length.toString()),
            ],
          ),
        ),
      );
  }
}


class SessionAttributes extends StatefulWidget {
  const SessionAttributes(this._attributeName, this._attribut, this._width,{Key? key}) : super(key: key);
  final String _attributeName, _attribut;
  final double _width;


  @override
  _SessionAttributesState createState() => _SessionAttributesState();
}

class _SessionAttributesState extends State<SessionAttributes> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget._width*0.4,
          child: Text(widget._attributeName, style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        ),
        SizedBox(
          width: widget._width*0.4,
          child: Text(widget._attribut, style: const TextStyle(
            fontSize: 16,
          ),),
        ),
      ],
    );
  }
}
Future<String?> getSessionsDone() async{
  final _prefs = await SharedPreferences.getInstance();
  if(_prefs.getInt('SESSIONS_DONE') == null){
    return Future<int>.value(0).toString();
  }
  return _prefs.getInt('SESSIONS_DONE').toString();
}