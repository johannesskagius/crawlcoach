import 'package:crawl_course_3/account/user.dart';
import 'package:flutter/material.dart';

class UserSettings extends StatelessWidget {
  UserSettings(this._localUser, {Key? key}) : super(key: key);
  LocalUser? _localUser;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    List<TextEditingController> _txtEditList =
        List.generate(3, (index) => TextEditingController());

    return Scaffold(
        appBar: AppBar(
          title: Text('Update user'),
        ),
        body: SizedBox(
          height: _height,
          width: _width,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
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
                          autofocus: true,
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
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.always,
                          controller: _txtEditList.elementAt(1),
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'email',
                            labelText: 'Email',
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
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: AutovalidateMode.always,
                          controller: _txtEditList.elementAt(2),
                          autofocus: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'minimum 6 characters'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter a password';
                            }
                            if (value.length < 6) {
                              return 'please enter a correct email';
                            }
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_localUser!.firstName ==
                                    _txtEditList.elementAt(0).value.text) {
                                  //update name,
                                  String _name = _txtEditList.elementAt(0).value.text;
                                  _localUser!.firstName;
                                }
                                if (_localUser!.email !=
                                    _txtEditList.elementAt(1).value.text) {
                                  //Update email
                                }
                                if (_localUser!.password !=
                                    _txtEditList.elementAt(2).value.text) {
                                  //Update password
                                }
                              }
                            },
                            child: const Text('create user')),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
