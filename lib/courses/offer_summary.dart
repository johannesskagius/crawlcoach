import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'offer.dart';

class OfferSummary extends StatefulWidget {
  const OfferSummary(this._offer, this._img, {Key? key}) : super(key: key);
  final Offer _offer;
  final File? _img;

  @override
  State<OfferSummary> createState() => _OfferSummaryState();
}

class _OfferSummaryState extends State<OfferSummary> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  bool uploading = false;
  bool _gotPic = false;
  File? img;

  void _isUploading() {
    setState(() {
      uploading = true;
    });
  }

  void _uploadingIsComplete() {
    setState(() {
      uploading = false;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget._img != null) {
      _gotPic = true;
      setState(() {
        img = widget._img!;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: ListView(
        children: [
          _gotPic ? Image.file(img!) : Container(),
          const Divider(
            height: 10,
          ),
          widget._offer.previewTable(),
          ElevatedButton(
            onPressed: () async {
              if (widget._img != null) {
                widget._offer
                    .uploadImageToServer(img!)
                    .then((value) => _isUploading())
                    .whenComplete(() => {
                          _uploadingIsComplete(),
                        });
              }
              _ref
                  .child('courses')
                  .child(widget._offer.name.toString())
                  .set(widget._offer.toJson());
            },
            child: const Text('To Server'),
          )
        ],
      ),
    );
  }
}
