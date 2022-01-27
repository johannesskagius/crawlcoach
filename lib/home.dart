import 'dart:convert';

import 'package:crawl_course_3/session/session.dart';
import 'package:crawl_course_3/account/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height-AppBar().preferredSize.height;
    final _width = MediaQuery.of(context).size.width;

    Future<LocalUser> getLocalUser() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      try {
        Map<String, dynamic> userMap =
        jsonDecode(sharedPreferences.getString('USER_CRED')!);
        LocalUser _localUser = LocalUser.fromJson(userMap);
        _localUser.doesHaveAUser();
        return _localUser;
      } catch (exception) {
        return LocalUser('','', '', '');
      }
    }

    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      body: SizedBox(
        height: _height,
        width: _width,
        child: FutureBuilder(future: getLocalUser(),
          builder: (BuildContext context, AsyncSnapshot<LocalUser> snapshot) {
            String _userName='';
            if(snapshot.hasData){
              _userName = snapshot.data!.firstName;
          }
            return Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: _height,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: _height*0.2,
                        width: _width*.8,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Today is your opportunity to build the tomorrow you want',
                            style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      // SessionPreview(Session('First session', CurrentExercises().exercises,
                      //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')),
                    ],
                  ),
                  Text(_userName),
                ],
              )
            );
          },
        )
      ),
    );
  }
}
