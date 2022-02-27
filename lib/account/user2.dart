import 'dart:convert';

import 'package:crawl_course_3/admin/courses/offer.dart';
import 'package:crawl_course_3/session/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User2 {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  static final String _localUser = "USER_CRED";
  String _email, _password, userAuth;
  int currentTip = 0;

  User2(this._email, this._password, this.userAuth);

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

  void markSessionDone(Session _session) async {
    DatabaseReference _sessionRef = _ref.child('users').child(userAuth);
    DataSnapshot snap =
        await _sessionRef.child('assigned_sessions').child('Test').get();

    //Offer offer = snap.children.toList();
    List<Offer> offers = [];
    for (DataSnapshot data in snap.children) {
      print(data.value);
      offers.add(Offer.fromJson(data.value));
    }

    //_sessionRef.child('assigned_sessions').set(notDoneSessions);
    //_sessionRef.child('completed_sessions').child(_session.sessionName);
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
      // FirebaseAuth _auth = FirebaseAuth.instance;
      // _auth.signInAnonymously();
      //throw Exception;
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
    _ref
        .child('users')
        .child(userAuth)
        .child('assigned_sessions')
        .child(_offer.name)
        .set(_offer.toJson());
  }

  Map<String, dynamic> toJson() => {
        '_password': _password,
        '_email': _email,
        '_userAuth': userAuth,
      };

  void _syncToServer() {
    _ref.child('users').child(userAuth).set('1');

    //Set to completed no intro sessions
  }

  static void assignToOffer(Offer _offer) {
    _ref
        .child('users')
        .child('1')
        .child('assigned_sessions')
        .child(_offer.name)
        .set(_offer.toJson());
  }

  void sendTip(List<String> test) {
    _ref
        .child('improvement')
        .child(userAuth)
        .child(currentTip.toString())
        .set(test);
    currentTip++;
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
    return _ref.child('admins').child(user2!.userAuth).child('isadmin').get()
        as bool;
  }
}
