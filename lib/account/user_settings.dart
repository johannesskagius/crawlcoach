import 'package:crawl_course_3/account/user2.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  const UserSettings(this._user, {Key? key}) : super(key: key);
  final User2 _user;

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String nrOfCourses = '';

  void getNrOfSessions() async {
    String s = await widget._user.getNrOfAssignedCourses();
    setState(() {
      nrOfCourses = s;
    });
  }

  @override
  void initState() {
    getNrOfSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _rowHeight = _height * 0.3;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(8),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => print('update user'),
            child: Container(
              color: Colors.transparent,
              child: Table(
                columnWidths: <int, TableColumnWidth>{
                  0: FixedColumnWidth(_width * 0.3),
                  1: const FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(children: [
                    _textContainer(_rowHeight, 'USER ID: '),
                    _textContainer(_rowHeight, widget._user.userAuth),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Email: '),
                    _textContainer(_rowHeight, widget._user.email),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Courses on: '),
                    _textContainer(_rowHeight, nrOfCourses),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Sessions to do: '),
                    _textContainer(_rowHeight, '10'),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Sessions done: '),
                    _textContainer(_rowHeight, '10'),
                  ]),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                User2.logOutUser();
              },
              child: const Text('Sign out')),
        ],
      ),
    );
  }
}

Container _textContainer(double _height, String s) {
  return Container(
      height: _height * 0.1, alignment: Alignment.center, child: Text(s));
}