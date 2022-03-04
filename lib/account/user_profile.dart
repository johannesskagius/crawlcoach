import 'package:crawl_course_3/account/user2.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatelessWidget {
  const UpdateUser(this._user, {Key? key}) : super(key: key);
  final User2 _user;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Do you have a preferred name?'),
                onSaved: (value) {
                  User2.firebaseAuth.currentUser!.updateDisplayName(value);
                },
              ),
              TextFormField(
                initialValue: _user.email,
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
                onFieldSubmitted: (value) {
                  //todo update email
                  if (_formKey.currentState!.validate()) {
                    User2.firebaseAuth.currentUser!
                        .verifyBeforeUpdateEmail(value);
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    User2.firebaseAuth
                        .sendPasswordResetEmail(email: _user.email)
                        .whenComplete(() =>
                            AlertDialog(title: Text('Text')).createElement());
                  },
                  child: const Text('Update password')),
            ],
          ),
        ),
      ),
    );
  }
}

class UserEmail extends StatelessWidget {
  const UserEmail(this.isActive, this._user, {Key? key}) : super(key: key);
  final User2 _user;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Future<String?> getUserName() async {
      return User2.firebaseAuth.currentUser!.displayName;
    }

    final _height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final _rowHeight = _height * 0.3;
    final _width = MediaQuery.of(context).size.width;
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(_width * 0.3),
        1: const FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          _title(_rowHeight, 'Name ID: '),
          FutureBuilder(
            future: getUserName(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasData) {
                String reply = snapshot.requireData.toString();
                return _userInfo(_rowHeight, reply, isActive);
              } else {
                return _userInfo(_rowHeight, '', isActive);
              }
            },
          ),
        ]),
        TableRow(children: [
          _title(_rowHeight, 'USER ID: '),
          _userInfo(_rowHeight, _user.userAuth, isActive),
        ]),
        TableRow(children: [
          _title(_rowHeight, 'Email: '),
          _userInfo(_rowHeight, _user.email, isActive),
        ]),
        TableRow(children: [
          _title(_rowHeight, 'Courses on: '),
          _userInfo(_rowHeight, 'nrOfCourses', isActive),
        ]),
        TableRow(children: [
          _title(_rowHeight, 'Sessions to do: '),
          _userInfo(_rowHeight, '10', isActive),
        ]),
        TableRow(children: [
          _title(_rowHeight, 'Sessions done: '),
          _userInfo(_rowHeight, '10', isActive),
        ]),
      ],
    );
  }
}

Container _title(double _height, String s) {
  return Container(
      height: _height * 0.1, alignment: Alignment.center, child: Text(s));
}

Container _userInfo(double _height, String s, bool isActive) {
  return Container(
      height: _height * 0.1, alignment: Alignment.center, child: Text(s));
}
