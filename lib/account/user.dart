import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  LocalUser(this._firstName, this._email, this._password, this._userAuth2);
  String _firstName,_password, _email, _userAuth2;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  static const String _GOTUSER = 'GOT_USER';

  Map<String, dynamic> toJson() => {
        '_firstName': _firstName,
        '_password':_password,
        '_email': _email,
        '_userAuth2': _userAuth2,
      };

  get password => _password;
  set password(value) {
    _password = value;
  }

  static Future<LocalUser> getLocalUser() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap =
    jsonDecode(sharedPreferences.getString('USER_CRED')!);
    return LocalUser.fromJson(userMap);
  }

  static void logOutUser(){
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
    _resetLastUser();
  }




  static _resetLastUser() async{
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('USER_CRED', '');
  }

  void doesHaveAUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(_GOTUSER, true);
  }

  Future<bool> gotUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_GOTUSER) ?? false;
  }
  
  //create user space in realtimeDatabase
  void syncToServer() async {
    try {
      //Create user json on firebase
      await _ref.child('users').child(_userAuth2).update(toJson()).catchError((o) => print(o));
      //Set to done no intro sessions
      await _ref.child('users').child(_userAuth2).child('intro_sessions').set(false);
    } catch (e) {
      print(e);
    }
  }

  LocalUser.fromJson(Map<String, dynamic> json)
      : _firstName = json['_firstName'],
        _password = json['_password'],
        _email = json['_email'],
        _userAuth2 = json['_userAuth2'];

  void saveToSharedPreferences() async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String json = jsonEncode(toJson());
      await sharedPreferences.setString('USER_CRED', json + '\n');
    } catch (e) {
      print(e);
    }
  }

  Future<LocalUser> getUserFromJson(String s) async {
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
    return '_User{_firstName: $_firstName, _email: $_email}';
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
