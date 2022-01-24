import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  void start() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Account(),
    );
  }
}

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    String _imgSource = 'assets/human.jpg';
    _User? user;

    List<TextEditingController> _txtEditList =
        List.generate(3, (index) => TextEditingController());
    _txtEditList.elementAt(0).text = 'johannes';
    _txtEditList.elementAt(1).text = 'skagius';
    _txtEditList.elementAt(2).text = 'johannesskagius@gmail.com';

    void createUser() async {
      user = _User(
          _txtEditList.elementAt(0).value.text,
          _txtEditList.elementAt(1).value.text,
          _txtEditList.elementAt(2).value.text);
      //User is created, upload to server
      user!._register();
      //
    }

    /// Get from gallery
    void _getFromGallery() async {
      print('here');
      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(pickedFile != null){
        setState(() {
          _imgSource = pickedFile.path;
        });
      }
    }

    return SizedBox(
      height: _height,
      width: _width,
      child: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: _getFromGallery,
              child: SizedBox(
                height: _height / 4,
                width: _width / 2,
                child: Image.asset(_imgSource,
                fit: BoxFit.cover,),
              ),
            ),
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
                      decoration: const InputDecoration(
                        hintText: 'Johannes',
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
                      controller: _txtEditList.elementAt(1),
                      decoration: const InputDecoration(
                        hintText: 'Skagius',
                        labelText: 'Last name',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.name,
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
                      controller: _txtEditList.elementAt(2),
                      decoration: const InputDecoration(
                        hintText: 'email',
                        labelText: 'Last name',
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
                    ElevatedButton(
                        onPressed: createUser, child: const Text('create user'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class _User {
  _User(this._firstName, this._lastName, this._email);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _firstName, _lastName, _email;
  String? _userAuth2;

  Future<void> _register() async {
    User? user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
              email: _email, password: 'test1234'))
          .user;
      _userAuth2 = await user!.getIdToken();
      print(_userAuth2);
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

    if (user != null) {
      //TODO flytta nyckeln till egen klass
      const String USERTOKEN = 'userToken';
      SharedPreferences _shared = await SharedPreferences.getInstance();
      _shared.setString(USERTOKEN, user.uid);
    }
  }

  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
  }

  get lastName => _lastName;
  set lastName(value) {
    _lastName = value;
  }

  get email => _email;
  set email(value) {
    _email = value;
  }

  @override
  String toString() {
    return '_User{_firstName: $_firstName, _lastName: $_lastName, _email: $_email}';
  }
}
