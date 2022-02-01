
import 'package:flutter/material.dart';

import 'offer_chose_sessions.dart';

class AddOffer extends StatelessWidget {
  const AddOffer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Offer'),
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
  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> _txtEditList =
    List.generate(3, (index) => TextEditingController());
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
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.always,
              minLines: 1,
              maxLines: 4,
              controller: _txtEditList.elementAt(2),
              decoration: const InputDecoration(
                  hintText: 'USD 19,99', labelText: 'Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'error';
                }
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseSessions(
                                _txtEditList.elementAt(0).value.text,
                                _txtEditList.elementAt(1).value.text)));
                  }
                },
                child: const Text('Pick sessions')),
          ],
        ),
      ),
    );
  }
}
