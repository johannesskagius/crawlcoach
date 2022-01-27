import 'dart:convert';

import 'package:crawl_course_3/account/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account/user_settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();
    List<TextEditingController> _txtEditList =
    List.generate(3, (index) => TextEditingController());

    //return const CreateUser();
    return FutureBuilder(future: LocalUser.getLocalUser(),
      builder: (BuildContext context, AsyncSnapshot<LocalUser> snapshot) {
      if(snapshot.hasData){
        return SignedIn(snapshot.data);
      }else{
        return const CreateUser();
      }
      },
    );
  }
}



class SignedIn extends StatelessWidget {
  const SignedIn(this._localUser, {Key? key}) : super(key: key);
  final LocalUser? _localUser;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();

    List<TextEditingController> _txtEditList =
    List.generate(3, (index) => TextEditingController());
    // _txtEditList.elementAt(0).text = _fName;
    // _txtEditList.elementAt(1).text = _lName;
    // _txtEditList.elementAt(2).text = _email;

    return SizedBox(
      width: _width,
      height: _height,
      child: Column(
        children: [
          SizedBox(
            height: _height*0.5,
            child: Form(
              key: _formKey, child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    SizedBox(width: _width*.5, child: const Text('Name'),),
                    SizedBox(width: _width*.5, child: Text(_localUser!.firstName),),
                  ],
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    SizedBox(width: _width*.5, child: const Text('Email: '),),
                    SizedBox(width: _width*.5, child: Text(_localUser!.email),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate()){
                        //todo update user
                      }
                    }, child: Text('Sign out')),
                    ElevatedButton(onPressed: (){
                      //Todo send a new password,
                      LocalUser.logOutUser();
                    }, child: Text('Change password')),
                  ],
                )
              ],
            ),
            ),
          ),

        ],
      ),
    );
  }
}


//

//TODO use later for a more interactive experience,
//SizedBox(
//         height: _height,
//         width: _width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//
//               ],
//             )
//           ],
//         ),
//       ),
