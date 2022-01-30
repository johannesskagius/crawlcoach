import 'dart:io' show Platform;

import 'package:crawl_course_3/account/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account/create_user.dart';


Container _textContainer(double _height, String s) {
  return Container(
      height: _height * 0.1, alignment: Alignment.center, child: Text(s));
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class SignedIn extends StatelessWidget {
  final LocalUser? _localUser;
  const SignedIn(this._localUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    final _rowHeight = _height * 0.3;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Table(
              columnWidths: <int, TableColumnWidth>{
                0: FixedColumnWidth(_width * 0.3),
                1: const FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(children: [
                  _textContainer(_rowHeight, 'USER ID: '),
                  _textContainer(_rowHeight, _localUser!.userAuth2),
                ]),
                TableRow(children: [
                  _textContainer(_rowHeight, 'Name: '),
                  _textContainer(_rowHeight, _localUser!.firstName),
                ]),
                TableRow(children: [
                  _textContainer(_rowHeight, 'Email: '),
                  _textContainer(_rowHeight, _localUser!.email),
                ]),
                TableRow(children: [
                  _textContainer(_rowHeight, 'Courses on: '),
                  _textContainer(_rowHeight, '2'),
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
            Platform.isIOS
                ? const Center(
                    child: CupertinoButton(
                    onPressed: LocalUser.logOutUser,
                    child: Text('Sign out'),
                  ))
                : const ElevatedButton(
                    onPressed: LocalUser.logOutUser, child: Text('Sign out')),
          ],
        ),
      ),
    );
  }
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    List.generate(3, (index) => TextEditingController());

    //return const CreateUser();
    return FutureBuilder(
      future: LocalUser.getLocalUser(),
      builder: (BuildContext context, AsyncSnapshot<LocalUser?> snapshot) {
        if (snapshot.hasData) {
          return SignedIn(snapshot.data);
        } else {
          return const CreateUser();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
