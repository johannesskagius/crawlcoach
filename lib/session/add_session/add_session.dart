import 'dart:convert';

import 'package:crawl_course_3/session/add_session/session_exercises.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddSession extends StatelessWidget {
  const AddSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Session'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: SizedBox(
          width: _width * 0.9,
          height: _height,
          child: SessionGeneral(),
        ),
      ),
    );
  }
}

class SessionGeneral extends StatelessWidget {
  SessionGeneral({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String _name ='';
  String _desc ='';
  @override
  Widget build(BuildContext context) {

    final List<TextEditingController> _txtEditList =
    List.generate(4, (index) => TextEditingController());
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.always,
              controller: _txtEditList.elementAt(0),
              decoration: const InputDecoration(
                  hintText: 'Intro crawl', labelText: 'Session name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Session name';
                }
              },
              onSaved: (value){_name = value!;},
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              autovalidateMode: AutovalidateMode.always,
              minLines: 1,
              maxLines: 4,
              controller: _txtEditList.elementAt(1),
              decoration: const InputDecoration(
                  hintText: 'Describe it', labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'error';
                }
              },
              onSaved: (value){_desc = value!;},
            ),
            ElevatedButton(onPressed: (){
              if(_formKey.currentState!.validate()){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SessionExercises(_name, _desc)));
              }
            }, child: Text('Show exercises')),
          ],
        ),
      ),
    );
  }
}
