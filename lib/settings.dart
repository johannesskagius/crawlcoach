import 'dart:convert';
import 'dart:math';

import 'package:crawl_course_3/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late LocalUser _localUser;
  late String userJson;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Account(), //,
    );
  }
}

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  LocalUser? _localUser;
  String _fName = '';
  String _lName = '';
  String _email = '';
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap =
          jsonDecode(sharedPreferences.getString('USER_CRED')!);
      _localUser = LocalUser.fromJson(userMap);
      setState(() {
        _fName = _localUser!.firstName;
        _lName = _localUser!.lastName;
        _email = _localUser!.email;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference database = FirebaseDatabase.instance.ref();

    final _formKey = GlobalKey<FormState>();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    String _imgSource = 'assets/human.jpeg';

    List<TextEditingController> _txtEditList =
        List.generate(3, (index) => TextEditingController());

    _txtEditList.elementAt(0).text = _fName;
    _txtEditList.elementAt(1).text = _lName;
    _txtEditList.elementAt(2).text = _email;

    Future<void> _createUser() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      String _userAuth2 = '';
      User? user;
      try {
        user = (await _auth.createUserWithEmailAndPassword(
                email: _txtEditList.elementAt(2).value.text,
                password: 'test1234'))
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
        //TODO flytta nyckeln till egen klass
        LocalUser _newLocalUser = LocalUser(
            _txtEditList.elementAt(0).value.text,
            _txtEditList.elementAt(1).value.text,
            _txtEditList.elementAt(2).value.text,
            _userAuth2);

        _newLocalUser.saveToSharedPreferences();
        _newLocalUser.syncToServer();
      }
    }

    /// Get from gallery
    void _getFromGallery() async {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
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
                child: Image.asset(
                  _imgSource,
                  fit: BoxFit.cover,
                ),
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
                      controller: _txtEditList.elementAt(1),
                      decoration: const InputDecoration(
                        hintText: 'Andersson',
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
                        onPressed: _createUser,
                        child: const Text('create user')),
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
