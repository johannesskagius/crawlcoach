import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  LocalUser(this._firstName, this._lastName, this._email, this._userAuth2);
  String _firstName, _lastName, _email, _userAuth2;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  Map<String, dynamic> toJson() => {
    '_firstName': _firstName,
    '_lastName': _lastName,
    '_email': _email,
    '_userAuth2': _userAuth2,
  };

  //create user space in realtimeDatabase
  void syncToServer() async {
    await _ref.child(_email).set(toJson());
  }


  LocalUser.fromJson(Map<String, dynamic> json)
  :_firstName = json['_firstName'],
        _lastName = json['_lastName'],
        _email = json['_email'],
        _userAuth2 = json['_userAuth2'];

  
  void saveToSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String json = jsonEncode(toJson());
    print(json);
    await sharedPreferences.setString('USER_CRED', json + '\n');

//    print(_localUser.toString());
  }

  Future<LocalUser> getUserFromJson(String s) async{
    Map<String, dynamic> userMap = jsonDecode(s);
    LocalUser _localUser = LocalUser.fromJson(userMap);
    return _localUser;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }
  

  @override
  String toString() {
    return '_User{_firstName: $_firstName, _lastName: $_lastName, _email: $_email}';
  }

  String get lastName => _lastName;

  set lastName(value) {
    _lastName = value;
  }

  String get email => _email;

  set email(value) {
    _email = value;
  }

  String get userAuth2 => _userAuth2;

  set userAuth2(String value) {
    _userAuth2 = value;
  }
}


