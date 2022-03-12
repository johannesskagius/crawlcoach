import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account/not_logged_user.dart';
import 'account/user2.dart';
import 'account/user_settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<String> _loggedInTitles = ['User settings', 'Feedback'];
  final List<String> _loggedOutTitle = ['Log in', 'CreateUser'];
  final pControll = PageController();
  User2? user2;
  bool hasLoggedIn = false;
  List<Widget> _widgets = [];

  @override
  void initState() {
    checkIfAnonymous();
    super.initState();
  }

  void checkIfAnonymous() async {
    User2.firebaseAuth.userChanges().listen((event) async {
      if (User2.firebaseAuth.currentUser == null ||
          User2.firebaseAuth.currentUser!.isAnonymous) {
        _widgets = notLoggedIn();
      } else {
        String? email = await event!.email;
        final user = User2(email!, 'test12', event.uid);
        _widgets = loggedIn(user);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          PageView(
            scrollDirection: Axis.vertical,
            controller: pControll,
            pageSnapping: true,
            children: _widgets,
          ),
        ],
      ),
    ));
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
