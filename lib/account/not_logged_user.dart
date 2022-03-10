import 'package:crawl_course_3/account/user2.dart';
import 'package:flutter/material.dart';

class LogInUser extends StatelessWidget {
  LogInUser({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _txtEditList = List.generate(2, (index) => TextEditingController());
    //_txtEditList.elementAt(0).text = 'test@gmail.com';
    //_txtEditList.elementAt(1).text = 'test12';
    return Container(
      margin: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _emailForm(_txtEditList.elementAt(0)),
            _passwordForm(_txtEditList.elementAt(1)),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _signInUser(_txtEditList.elementAt(0).value.text,
                      _txtEditList.elementAt(1).value.text);
                }
              },
              child: const Text('Log in'),
            ),
            const Text('Create user by swiping down'),
          ],
        ),
      ),
    );
  }

  _signInUser(String email, String pss) async {
    bool loggedIn = await User2.signInUser(email, pss);
    if (loggedIn) {
      //reload;
    }
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Create user by swiping up'),
            _emailForm(_txtEditList.elementAt(0)),
            _passwordForm(_txtEditList.elementAt(1)),
            ElevatedButton(
              onPressed: () async {
                String? reply = '';
                if (_formKey.currentState!.validate()) {
                  reply = await User2.createUser(
                      _txtEditList.elementAt(0).value.text,
                      _txtEditList.elementAt(1).value.text);
                }
                if (reply == '') {
                  //reload;
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _alertDialog(reply!, context));
                }
              },
              child: const Text('Create user'),
            ),
          ],
        ),
      ),
    );
  }

  void sendAlert(String reply, BuildContext context) {
    AlertDialog(
      title: const Text('Error'),
      content: Text(reply),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('OK'))
      ],
    );
  }
}

AlertDialog _alertDialog(String reply, BuildContext context) {
  return AlertDialog(
    title: const Text('Error'),
    content: Text(reply),
    actions: [
      TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('OK'))
    ],
  );
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
      return null;
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
      return null;
    },
  );
}
