
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account/not_logged_user.dart';
import 'account/user2.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class SignedIn extends StatelessWidget {
  final User2? _localUser;

  SignedIn(this._localUser, {Key? key}) : super(key: key);
  List<String> _titles = ['Log in', 'Create user'];
  String _title = 'Log in';

  @override
  Widget build(BuildContext context) {
    final pControl = PageController();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Settings', style: TextStyle(color: Colors.greenAccent)),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: pControl,
        pageSnapping: true,
        children: [
          LogInUser(),
          CreateUser(),
        ],
      ),
    );
  }
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: User2.getLocalUser(),
      builder: (BuildContext context, AsyncSnapshot<User2?> snapshot) {
        if (snapshot.hasData) {
          return SignedIn(snapshot.data);
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}


