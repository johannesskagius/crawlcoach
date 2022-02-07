
import 'dart:io';

import 'package:crawl_course_3/account/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final List<TextEditingController> _txtEditList =
      List.generate(3, (index) => TextEditingController());
  bool _focus = true;

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
    final _formKey = GlobalKey<FormState>();

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

    return GestureDetector(
      onTap: () => {
        FocusManager.instance.primaryFocus?.unfocus(),
        setState(() {
          _focus = false;
        }),
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create user'),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _txtEditList.elementAt(0),
                      autofocus: _focus,
                      onTap: () {
                        setState(() {
                          _focus = true;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'John',
                        labelText: 'First name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _txtEditList.elementAt(1),
                      decoration: const InputDecoration(
                        hintText: 'email',
                        labelText: 'Email',
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
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _txtEditList.elementAt(2),
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'minimum 6 characters'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter a password';
                        }
                        if (value.length < 6) {
                          return 'please enter a correct email';
                        }
                      },
                    ),
                    Platform.isIOS
                        ? Column(
                            children: [
                              CupertinoButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _createUser();
                                    }
                                  },
                                  child: const Text('create user')),
                              SignInWithAppleButton(onPressed: () async {
                                final _credential =
                                    await SignInWithApple.getAppleIDCredential(
                                        scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ]);
                                final _auth = FirebaseAuth.instance;
                                _auth.signInWithCustomToken(
                                    _credential.authorizationCode);
                              })
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _createUser();
                              }
                            },
                            child: const Text('create user')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
