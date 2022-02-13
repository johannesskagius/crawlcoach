import 'package:crawl_course_3/account/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotLoggedUser extends StatefulWidget {
  const NotLoggedUser({Key? key}) : super(key: key);

  @override
  State<NotLoggedUser> createState() => _NotLoggedUserState();
}

class _NotLoggedUserState extends State<NotLoggedUser> {
  final List<TextEditingController> _txtEditList =
      List.generate(3, (index) => TextEditingController());
  List<String> _titles = ['Log in', 'Create user'];
  String _title = 'Log in';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pControll = PageController();

    Future<void> _createUser() async {
      String _userAuth2 = '';
      User? user;
      try {
        user = (await LocalUser.firebaseAuth.createUserWithEmailAndPassword(
                email: _txtEditList.elementAt(1).value.text,
                password: _txtEditList.elementAt(2).value.text))
            .user;
        _userAuth2 = user!.uid;
      } catch (error) {
        switch (error) {
          //TODO fix the error codes. we want different things to happen depending the response from the server.
          case 'email-already-exists': //Går aldrig in här.
            print('This email is already in use');
            break;
          default:
            print(error.toString());
        }
      }
      if (user != null && _userAuth2 != '') {
        LocalUser _newLocalUser = LocalUser(
            _txtEditList.elementAt(0).value.text, //Firstname
            _txtEditList.elementAt(1).value.text, //Email
            _txtEditList.elementAt(2).value.text, //Password
            _userAuth2); //userID
        _newLocalUser.saveToSharedPreferences();
        _newLocalUser.syncToServer();
      }
    }

    void _onPageChanged(int index) {
      setState(() {
        _title = _titles.elementAt(index);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Stack(
        children: [
          PageView(
            scrollDirection: Axis.vertical,
            controller: pControll,
            onPageChanged: _onPageChanged,
            pageSnapping: true,
            children: [
              LogInUser(),
              CreateUser(),
            ],
          )
        ],
      ),
    );
  }
}

class LogInUser extends StatelessWidget {
  LogInUser({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> _txtEditList =
        List.generate(2, (index) => TextEditingController());

    return Container(
      margin: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _emailForm(_txtEditList.elementAt(0)),
            _passwordForm(_txtEditList.elementAt(1)),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await LocalUser.firebaseAuth.signInWithEmailAndPassword(
                      email: _txtEditList.elementAt(0).value.text,
                      password: _txtEditList.elementAt(1).value.text);
                }
              },
              child: const Text('Log in'),
            )
          ],
        ),
      ),
    );
  }
}

class CreateUser extends StatelessWidget {
  CreateUser({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> _txtEditList =
        List.generate(2, (index) => TextEditingController());
    return Container(
      margin: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _emailForm(_txtEditList.elementAt(0)),
            _passwordForm(_txtEditList.elementAt(1)),
          ],
        ),
      ),
    );
  }
}

TextFormField _emailForm(TextEditingController _controller) {
  return TextFormField(
    controller: _controller,
    keyboardType: TextInputType.emailAddress,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: const InputDecoration(
      icon: Icon(Icons.email_outlined),
      hintText: 'your@email.com',
      label: Text('Email*'),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'please enter your email';
      }
      var email = value;
      bool isValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!isValid) {
        return 'please enter a correct email';
      }
    },
  );
}

TextFormField _passwordForm(TextEditingController _controller) {
  return TextFormField(
    controller: _controller,
    decoration: const InputDecoration(
      icon: Icon(Icons.password_outlined),
      hintText: 'Put something clever :) ',
      label: Text('Password*'),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'please enter your email';
      } else if (value.isNotEmpty && value.length < 5) {
        return 'Please enter a password longer than 5 characters';
      }
    },
  );
}
