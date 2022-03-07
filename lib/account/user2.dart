import 'dart:async';
import 'dart:convert';

import 'package:crawl_course_3/courses/offer.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User2 {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('users');
  static const String _localUser = "USER_CRED";
  String _email, _password, userAuth;
  int _currentTip = 0;

  User2(this._email, this._password, this.userAuth);

  get userID => null;

  static Future<String?> createUser(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User2 user2 = User2(email, password, userCredential.user!.uid);
        user2._saveToSharedPreferences();
        user2._syncToServer();
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  void markSessionDone(
      String sessionid, Session _session, String courseName) async {
    DatabaseReference _userRef = ref.child(userAuth);
    _userRef
        .child('c_sessions')
        .child(courseName)
        .child(_session.sessionName)
        .set('');
    _userRef
        .child('a_sessions')
        .child(courseName)
        .child('session')
        .child(_session.sessionName)
        .remove();
  }

  static Future<User2?> getLocalUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    try {
      User2 _local =
          User2.fromJson(jsonDecode(sharedPreferences.getString(_localUser)!));
      return _local;
    } catch (e) {
      print(e);
      //TODO When signed anonymosly, you can't create a new account
      return null;
    }
  }

  User2.fromJson(Map<String, dynamic> json)
      : _password = json['_password'],
        _email = json['_email'],
        userAuth = json['_userAuth'];

  void _saveToSharedPreferences() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String json = jsonEncode(toJson());
      await sharedPreferences.setString(_localUser, json + '\n');
    } catch (e) {
      print(e);
    }
  }

  void assignToCourse(Offer _offer) {
    ref
        .child(userAuth)
        .child('a_sessions')
        .child(_offer.name)
        .set(_offer.toJson());
  }

  Map<String, dynamic> toJson() => {
        '_password': _password,
        '_email': _email,
        '_userAuth': userAuth,
      };

  void _syncToServer() {
    ref.child(userAuth).set('1');

    //Set to completed no intro sessions
  }

  static void assignToOffer(Offer _offer) {
    ref
        .child('1')
        .child('assigned_sessions')
        .child(_offer.name)
        .set(_offer.toJson());
  }

  void sendTip(List<String> test) {
    ref
        .child('improvement')
        .child(userAuth)
        .child(_currentTip.toString())
        .set(test);
    _currentTip++;
  }

  static void logOutUser() {
    firebaseAuth.signOut();
    firebaseAuth.signInAnonymously();
    _resetLastUser();
  }

  static _resetLastUser() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.remove(_localUser);
  }

  static Future<bool> signInUser(String email, String pss) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pss);
    if (userCredential.user != null) {
      final User? user = userCredential.user;
      String? email = user!.email;
      User2 user2 = User2(email!, pss, user.uid);
      user2._saveToSharedPreferences();
      return true;
    }
    return false;
  }

  static Future<bool> signIn() async {
    User2? user2 = await getLocalUser();
    if (user2 != null) {
      signInUser(user2._email, user2._password);
      return true;
    }
    return false;
  }

  static Future<bool> isManager() async {
    User2? user2 = await getLocalUser();
    DataSnapshot snap = await FirebaseDatabase.instance
        .ref()
        .child('admins')
        .child(user2!.userAuth)
        .child('isadmin')
        .get();
    bool isManager = snap.value as bool;
    return isManager;
  }

  Future<String> getNrOfAssignedCourses() async {
    DataSnapshot data = await ref.child(userAuth).child('a_sessions').get();
    String s = data.children.length.toString();
    return s;
  }

  Future<int> getNrOfSessions() async {
    DataSnapshot data = await ref.child(userAuth).child('a_sessions').get();
    int count = 0;
    for (DataSnapshot _child in data.children) {
      count += _child.child('session').children.length;
    }
    return count;
  }

  Future<int> getDoneSessions() async {
    DataSnapshot _data = await ref.child(userAuth).child('c_sessions').get();
    int count = 0;
    for (DataSnapshot _child in _data.children) {
      count += _child.children.length;
    }
    return count;
  }
}
