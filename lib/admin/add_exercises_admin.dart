import 'package:crawl_course_3/session/excerise/abs_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'exercise_summary.dart';

class AddExercise extends StatelessWidget {
  const AddExercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> _txtEditList =
        List.generate(7, (index) => TextEditingController());
    _txtEditList.elementAt(0).text = 'TEST';
    _txtEditList.elementAt(1).text = 'Strengthen';
    _txtEditList.elementAt(2).text = 'Lats';
    _txtEditList.elementAt(3).text = 'Back';
    _txtEditList.elementAt(4).text = 'Strength';
    _txtEditList.elementAt(5).text =
        'https://www.youtube.com/watch?v=g7-xnvc3ap8';
    _txtEditList.elementAt(6).text = 'Hang on a bar, pull yourself up';
    final _formKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () =>
          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Exercise',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _exName(_txtEditList.elementAt(0)),
                _focusPoint(_txtEditList.elementAt(1)),
                _perk(_txtEditList.elementAt(2)),
                _perk(_txtEditList.elementAt(3)),
                _perk(_txtEditList.elementAt(4)),
                TextFormField(
                  keyboardType: TextInputType.url,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _txtEditList.elementAt(5),
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(
                      labelText: 'Video description',
                      hintText:
                          'Make sure to write a correct url, otherwise it won"t work'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter a description of the exercise';
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _txtEditList.elementAt(6),
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(
                      labelText: 'Bullet point',
                      hintText:
                          'Write bullet points to the exercise separate with comma (,)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter a description of the exercise';
                    }
                    if (value.length < 10) {
                      return 'please enter a correct email';
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Exercise _ex = Exercise(
                            _txtEditList.elementAt(5).value.text,
                            title: _txtEditList.elementAt(0).value.text,
                            subTitle: _txtEditList.elementAt(1).value.text,
                            perk1: _txtEditList.elementAt(2).value.text,
                            perk2: _txtEditList.elementAt(3).value.text,
                            perk3: _txtEditList.elementAt(4).value.text,
                            description: _txtEditList
                                .elementAt(6)
                                .value
                                .text
                                .split(','));

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExerciseSummary(_ex)));
                        for (TextEditingController controller in _txtEditList) {
                          controller.clear();
                        }
                      }
                    },
                    child: const Text('Add exercise')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _perk(TextEditingController _txtEditList) {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _txtEditList,
      decoration: const InputDecoration(
          labelText: 'perk', hintText: 'one word, max 10 characher'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please enter a perk';
        }
        if (value.length > 10) {
          return 'Too many letters';
        }
      },
    );
  }

  TextFormField _focusPoint(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
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
    );
  }
}

TextFormField _exName(TextEditingController _controller) {
  return TextFormField(
    keyboardType: TextInputType.name,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: _controller,
    decoration: const InputDecoration(
        labelText: 'title', hintText: 'minimum 3 characters'),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'please enter a title';
      }
      if (value.length < 2 && value.length > 10) {
        return 'please enter a correct email';
      }
    },
  );
}
