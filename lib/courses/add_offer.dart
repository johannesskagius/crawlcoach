import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'offer_chose_sessions.dart';

class AddOffer extends StatelessWidget {
  const AddOffer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Offer'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SessionGeneral(),
    );
  }
}

class SessionGeneral extends StatelessWidget {
  SessionGeneral({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

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
          child: Column(
            children: [
              const ImageView(),
              _courseName(_txtEditList),
              _courseDesc(_txtEditList),
              _coursePrice(_txtEditList),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseSessions(
                                  _txtEditList.elementAt(0).value.text,
                                  _txtEditList.elementAt(1).value.text,
                                  _txtEditList.elementAt(2).value.text)));
                    }
                  },
                  child: const Text('Pick sessions')),
            ],
          ),
        ),
      ),
    );
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
      autofocus: true,
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

class ImageView extends StatefulWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  String _asset = 'assets/human.jpeg';

  Future<void> _getImage(BuildContext c) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _asset = pickedFile!.path;
    });
    Navigator.pop(c);
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
                      _getImage(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        _showChoiceDialog();
      },
      child: Image.asset(_asset),
    );
  }
}
