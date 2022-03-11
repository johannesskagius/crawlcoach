import 'dart:io';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'offer_chose_sessions.dart';

class AddOffer extends StatelessWidget {
  const AddOffer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Add Offer',
          style: TextStyle(color: Colors.greenAccent),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: const SessionGeneral(),
    );
  }
}

class SessionGeneral extends StatefulWidget {
  const SessionGeneral({Key? key}) : super(key: key);

  @override
  State<SessionGeneral> createState() => _SessionGeneralState();
}

class _SessionGeneralState extends State<SessionGeneral> {
  final _formKey = GlobalKey<FormState>();
  String _asset = 'assets/human.jpeg';
  File? _photo;

  Future<void> _galleryImage(BuildContext c) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _asset = pickedFile!.path;
      _photo = File(pickedFile.path);
    });
    Navigator.pop(c);
  }

  void _cameraImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _asset = pickedFile!.path;
      _photo = File(pickedFile.path);
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;
    fiam.triggerEvent('t'); //TODO kolla vidare på iapp
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _txtEditList = List.generate(3, (index) => TextEditingController());
    return GestureDetector(
        onTap: () {
          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Scrollbar(
                child: ListView(children: [
                  _courseName(_txtEditList),
                  _courseDesc(_txtEditList),
                  _coursePrice(_txtEditList),
                  GestureDetector(
                    onLongPress: () async {
                      WidgetsBinding.instance?.focusManager.primaryFocus
                          ?.unfocus();
                      _showChoiceDialog();
                    },
                    child: _photo != null
                        ? Image.file(_photo!)
                        : Image.asset(_asset),
                  ),
                  _goNext(_formKey, _txtEditList, _asset)
                ]),
              ),
            )));
  }

  ElevatedButton _goNext(GlobalKey<FormState> _key,
      List<TextEditingController> _list, String _pic) {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChooseSessions(
                        _list.elementAt(0).value.text,
                        _list.elementAt(1).value.text,
                        _list.elementAt(2).value.text,
                        _photo)));
          }
        },
        child: const Text('Pick sessions'));
  }

  TextFormField _coursePrice(List<TextEditingController> _txtEditList) {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: 1,
      maxLines: 1,
      controller: _txtEditList.elementAt(2),
      decoration:
          const InputDecoration(hintText: 'USD 19,99', labelText: 'Price'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'error';
        }
      },
    );
  }

  TextFormField _courseDesc(List<TextEditingController> _txtEditList) {
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

  TextFormField _courseName(List<TextEditingController> _txtEditList) {
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

  Future<void> _showChoiceDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose option'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Gallery'),
                    leading: const Icon(Icons.photo_album_outlined),
                    onTap: () {
                      _galleryImage(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Camera'),
                    leading: const Icon(Icons.camera_alt_outlined),
                    onTap: () {
                      _cameraImage(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
