import 'package:flutter/material.dart';

import 'add_session_choose_exercises.dart';

class AddSession extends StatelessWidget {
  const AddSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Session',
          style: TextStyle(color: Colors.greenAccent),
        ),
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

class SessionGeneral extends StatefulWidget {
  SessionGeneral({Key? key}) : super(key: key);

  @override
  State<SessionGeneral> createState() => _SessionGeneralState();
}

class _SessionGeneralState extends State<SessionGeneral> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> _txtEditList =
        List.generate(2, (index) => TextEditingController());
    _txtEditList.elementAt(0).text = 'TEST';
    _txtEditList.elementAt(1).text = 'Strengthen';

    return Container(
      margin: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _sessionName(_txtEditList),
            _desc(_txtEditList),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SessionExercises(
                                _txtEditList.elementAt(0).value.text,
                                _txtEditList.elementAt(1).value.text)));
                  }
                },
                child: const Text('Show exercises')),
          ],
        ),
      ),
    );
  }

  TextFormField _desc(List<TextEditingController> _txtEditList) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
    );
  }

  TextFormField _sessionName(List<TextEditingController> _txtEditList) {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _txtEditList.elementAt(0),
      decoration: const InputDecoration(
          hintText: 'Intro crawl', labelText: 'Session name'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Session name';
        }
      },
    );
  }
}
