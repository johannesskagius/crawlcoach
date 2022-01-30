
import 'package:crawl_course_3/account/user.dart';
import 'package:crawl_course_3/account/user_settings.dart';
import 'package:flutter/material.dart';

import 'account/create_user.dart';

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
    return FutureBuilder(
      future: LocalUser.getLocalUser(),
      builder: (BuildContext context, AsyncSnapshot<LocalUser?> snapshot) {
        if (snapshot.hasData) {
          return SignedIn(snapshot.data);
        } else {
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
    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    final _rowHeight = _height*0.3;
    final _width = MediaQuery.of(context).size.width;

    List<TextEditingController> _txtEditList =
        List.generate(3, (index) => TextEditingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => UserSettings(_localUser)));},
              child: Table(
                columnWidths: <int, TableColumnWidth>{
                  0: FixedColumnWidth(_width * 0.3),
                  //0:FlexColumnWidth(),
                  //0: IntrinsicColumnWidth(),
                  1: const FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Name: '),
                    _textContainer(_rowHeight, _localUser!.firstName),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Email: '),
                    _textContainer(_rowHeight, _localUser!.email),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Courses on: '),
                    _textContainer(_rowHeight, '2'),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Sessions to do: '),
                    _textContainer(_rowHeight, '10'),
                  ]),
                  TableRow(children: [
                    _textContainer(_rowHeight, 'Sessions done: '),
                    _textContainer(_rowHeight, '10'),
                  ]),
                ],
              ),
            ),
            Center(
              child: OutlinedButton(onPressed: () {
                LocalUser.logOutUser();
              },
              child: Text('Sign out'),)
            ),
          ],
        ),
      ),
    )

        /*Container(
      margin: const EdgeInsets.all(8),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: _height * 0.2,
              child: Container(
                decoration: _boxDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Name'),
                        Text(_localUser!.firstName),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Email: '),
                        Text(_localUser!.email),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //todo update user
                              }
                            },
                            child: const Text('something')),
                        ElevatedButton(
                            onPressed: () {
                              //Todo send a new password,
                              LocalUser.logOutUser();
                            },
                            child: const Text('Sign out')),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.4,
              child: Container(
                decoration: _boxDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text('Assigned to: '),
                        Text(_localUser!.assignedCourses.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )*/
        ;
  }
}

BoxDecoration _boxDecoration =
    (BoxDecoration(border: Border.all(color: Colors.black54, width: 1)));

Container _textContainer(double _height, String s){
return Container(height: _height*0.1, alignment: Alignment.center ,child: Text(s));
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
