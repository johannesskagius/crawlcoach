import 'dart:convert';

import 'package:crawl_course_3/courses/offer.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  static const String _gotUser = 'USER_CRED';
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _password, _email, _userAuth2;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  Map<String, List<dynamic>> assignedCourses = {};
  final List<String> _listOfSessions = [];
  final List<String> _completedSessions = [];

  LocalUser(this._email, this._password, this._userAuth2);

  LocalUser.fromJson(Map<String, dynamic> json)
      : _password = json['_password'],
        _email = json['_email'],
        _userAuth2 = json['_userAuth2'];

  List<String> get completedSessions => _completedSessions;

  String get email => _email;

  set email(value) {
    _email = value;
  }

  List<String> get listOfSessions => _listOfSessions;

  get password => _password;
  set password(value) {
    _password = value;
  }


  String get userAuth2 => _userAuth2;

  set userAuth2(String value) {
    _userAuth2 = value;
  }

  void addSessionToList(List<String> value) {
    for (String _newValue in value) {
      if (!_listOfSessions.contains(_newValue)) {
        _listOfSessions.add(_newValue); // test
      }
    }
  }

  void assignToCourse(Offer _offer) {
    _ref
        .child('users')
        .child(_userAuth2)
        .child('assigned_sessions')
        .child(_offer.name)
        .set(_offer.listOfSessions);
  }

  Future<List<String>> completedSession() async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref();
    List<String> _x = [];
    DataSnapshot _data = await _ref
        .child('users')
        .child(_userAuth2)
        .child('done_sessions')
        .get();
    for (DataSnapshot snapshot in _data.children) {
      final String sessionTitle = snapshot.key.toString();
      _x.add(sessionTitle);
    }
    return _x;
  }

  Future<Session> getNextSession() async {
    _listOfSessions.elementAt(0);
    try {
      Object _session = await _ref
          .child('sessions')
          .child(_listOfSessions.elementAt(0))
          .get();
      return Session.fromJson(_session);
    } catch (e) {
      throw NullThrownError();
    }
  }

  //create user space in realtimeDatabase
  List<String> getNextSessions() {
    List<String> test = [];
    return test;
  }

  Future<LocalUser> getUserFromJson(String s) async {
    Map<String, dynamic> userMap = jsonDecode(s);
    LocalUser _localUser = LocalUser.fromJson(userMap);
    return _localUser;
  }

  void markSessionAsDone(String sessionKey) {
    _ref
        .child('users')
        .child(_userAuth2)
        .child('done_sessions')
        .child(sessionKey)
        .set(true);
    _listOfSessions.add(sessionKey);
  }

  void saveToSharedPreferences() async {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String json = jsonEncode(toJson());
      await sharedPreferences.setString('USER_CRED', json + '\n');
  }

  void syncToServer() async {
      await _ref.child('users').child(_userAuth2).update(toJson());
    //Set to completed no intro sessions
    await _ref
        .child('users')
        .child(_userAuth2)
        .child('intro_sessions')
        .set(false);
    await _ref
        .child('admins')
        .child(_userAuth2)
        .child('isadmin')
        .set(true); //TODO Take away later,
  }

  Map<String, dynamic> toJson() => {
    '_password': _password,
    '_email': _email,
    '_userAuth2': _userAuth2,
  };

  @override
  String toString() {
    return 'email: $_email';
  }

  void updateUserName() async {
    _ref
        .child('users')
        .child(_userAuth2)
        .update(toJson());
  }

  static Future<LocalUser?> getLocalUser() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    try {
      LocalUser _local = LocalUser.fromJson(
          jsonDecode(sharedPreferences.getString(_gotUser)!));
      return _local;
    } catch (e) {
      print(e);
      //TODO When signed anonymosly, you can't create a new account
      // FirebaseAuth _auth = FirebaseAuth.instance;
      // _auth.signInAnonymously();
      //throw Exception;
      return null;
    }
  }

  static void signInAno() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signInAnonymously();
  }

  static void logOutUser() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
    _resetLastUser();
    _auth.signInAnonymously();
  }

  static _resetLastUser() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.remove(_gotUser);
  }
}
