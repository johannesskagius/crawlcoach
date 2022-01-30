
import 'dart:io';

import 'package:crawl_course_3/account/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    List<TextEditingController> _txtEditList =
        List.generate(3, (index) => TextEditingController());


    Future<void> _createUser() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      String _userAuth2 = '';
      User? user;
      try {
        user = (await _auth.createUserWithEmailAndPassword(
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
      try {
        if (user != null && _userAuth2 != '') {
          LocalUser _newLocalUser = LocalUser(
              _txtEditList.elementAt(0).value.text, //Firstname
              _txtEditList.elementAt(1).value.text, //Email
              _txtEditList.elementAt(2).value.text, //Password
              _userAuth2); //userID
          _newLocalUser.saveToSharedPreferences();
          _newLocalUser.syncToServer();
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create user'),
      ),
      body: SizedBox(
        height: _height,
        width: _width,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: _width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _txtEditList.elementAt(0),
                        autovalidateMode: AutovalidateMode.always,
                        autofocus: true,
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
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(1),
                        autofocus: true,
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
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(2),
                        autofocus: true,
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
                      Platform.isIOS ? CupertinoButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _createUser();
                            }
                          },
                          child: const Text('create user')): ElevatedButton(onPressed: (){
                            if(_formKey.currentState!.validate()){
                              _createUser();
                            }
                      }, child: const Text('create user')),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
