

import 'dart:convert';

import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'exercise_summary.dart';

class AddExercise extends StatelessWidget {
  const AddExercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<TextEditingController> _txtEditList = List.generate(6, (index) => TextEditingController());
    _txtEditList.elementAt(0).text = 'Catch up';
    _txtEditList.elementAt(1).text = 'Flow';
    _txtEditList.elementAt(2).text = 'Grip';
    _txtEditList.elementAt(3).text = 'Rotation';
    _txtEditList.elementAt(4).text = 'Tempo';
    _txtEditList.elementAt(5).text = 'In your freestyle, catchup with the hands in streamline position';



    final _formKey = GlobalKey<FormState>();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final PageController _pControll = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      body: Center(
        child: SizedBox(
          width: _width*0.9,
          child: Scrollable(
              viewportBuilder: (BuildContext context, ViewportOffset position) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(0),
                        decoration: const InputDecoration(
                            labelText: 'title', hintText: 'minimum 3 characters'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a title';
                          }
                          if (value.length <2 && value.length > 10) {
                            return 'please enter a correct email';
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(1),
                        decoration: const InputDecoration(
                            labelText: 'Focuspoint', hintText: 'focus point'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a subtitle';
                          }
                          if (value.length > 10) {
                            return 'less than 10 characters';
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(2),
                        decoration: const InputDecoration(
                            labelText: 'Perk 1', hintText: 'one word, max 10 characher'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a perk';
                          }
                          if (value.length > 10 ) {
                            return 'Too many letters';
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(3),
                        decoration: const InputDecoration(
                            labelText: 'Perk 2', hintText: 'one word, max 10 characher'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a perk';
                          }
                          if (value.length > 10) {
                            return 'Too many letters';
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.always,
                        controller: _txtEditList.elementAt(4),
                        decoration: const InputDecoration(
                            labelText: 'Perk 3', hintText: 'one word, max 10 characher'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a perk';
                          }
                          if (value.length > 10) {
                            return 'Too many letters';
                          }
                        },
                      ),
                      Wrap(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            autovalidateMode: AutovalidateMode.always,
                            controller: _txtEditList.elementAt(5),
                            minLines: 1,
                            maxLines: 10, //TODO doesn't work
                            decoration: const InputDecoration(
                                labelText: 'Bullet point', hintText: 'Write bullet points to the exercise separate with comma (,)'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter a description of the exercise';
                              }
                              if (value.length < 10) {
                                return 'please enter a correct email';
                              }
                            },
                          )
                        ],
                      ),
                      ElevatedButton(onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          Exercise _ex = Exercise(
                              _txtEditList.elementAt(0).value.text,
                              _txtEditList.elementAt(1).value.text,
                              _txtEditList.elementAt(2).value.text,
                              _txtEditList.elementAt(3).value.text,
                              _txtEditList.elementAt(4).value.text,
                              _txtEditList.elementAt(5).value.text.split(',')
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ExerciseSummary(_ex)));

                          for(TextEditingController controller in _txtEditList){
                            controller.clear();
                          }
                        }
                      }, child: Text('Add exercise')),
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}

