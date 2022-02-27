import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account/not_logged_user.dart';
import 'account/user2.dart';

class Settings2 extends StatefulWidget {
  const Settings2({Key? key}) : super(key: key);

  @override
  _Settings2State createState() => _Settings2State();
}

class _Settings2State extends State<Settings2> {
  final List<String> _loggedInTitles = ['User settings', 'Feedback'];
  final List<String> _loggedOutTitle = ['Log in', 'CreateUser'];
  String _title = 'Log in';
  final pControll = PageController();
  User2? user2;
  bool hasLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  void _onPageChanged(int index) {
    setState(() {
      if (hasLoggedIn) {
        _title = _loggedInTitles.elementAt(index);
      } else {
        _title = _loggedOutTitle.elementAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder(
        future: User2.getLocalUser(),
        builder: (BuildContext context, AsyncSnapshot<User2?> snapshot) {
          List<Widget> _widgets = [];
          if (snapshot.hasData) {
            hasLoggedIn = true;
            final user2 = snapshot.data;
            _widgets = loggedIn(user2!);
          } else {
            _widgets = notLoggedIn();
          }
          return Stack(
            children: [
              PageView(
                scrollDirection: Axis.vertical,
                controller: pControll,
                onPageChanged: _onPageChanged,
                pageSnapping: true,
                children: _widgets,
              ),
            ],
          );
        },
      ),
    );
  }
}

List<Widget> loggedIn(User2 user) {
  return [
    UserSettings(user),
    GiveFeedBack(),
  ];
}

List<Widget> notLoggedIn() {
  return [
    LogInUser(),
    CreateUser(),
  ];
}

class UserSettings extends StatelessWidget {
  const UserSettings(this._user, {Key? key}) : super(key: key);
  final User2 _user;

  @override
  Widget build(BuildContext context) {
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _rowHeight = _height * 0.3;
    final _width = MediaQuery.of(context).size.width;
    return Container(
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
                _textContainer(_rowHeight, _user.userAuth),
              ]),
              TableRow(children: [
                _textContainer(_rowHeight, 'Email: '),
                _textContainer(_rowHeight, 'email'),
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

class GiveFeedBack extends StatelessWidget {
  GiveFeedBack({Key? key}) : super(key: key);
  final _titleCon = TextEditingController();
  final _feedBack = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _title(_titleCon),
                  _message(_feedBack),
                ],
              )),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  User2? user2 = await User2.getLocalUser();
                  String _title = _titleCon.value.text;
                  String _tip = _feedBack.value.text;
                  List<String> _test = [_title, _tip];
                  user2!.sendTip(_test);
                  _titleCon.clear();
                  _feedBack.clear();
                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                }
              },
              child: const Text('Submit')),
        ],
      ),
    );
  }
}

TextFormField _title(TextEditingController _controller) {
  return TextFormField(
    controller: _controller,
    keyboardType: TextInputType.text,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: const InputDecoration(
      icon: Icon(Icons.title_outlined),
      hintText: 'About settings',
      label: Text('Title*'),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'please enter some text';
      }
    },
  );
}

TextFormField _message(TextEditingController _controller) {
  return TextFormField(
    controller: _controller,
    minLines: 2,
    maxLines: 4,
    keyboardType: TextInputType.multiline,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: const InputDecoration(
      icon: Icon(Icons.message_outlined),
      hintText: 'Write your feedback',
      label: Text('Feedback*'),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'please enter some text';
      }
    },
  );
}
