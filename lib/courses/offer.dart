import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../account/user2.dart';

@JsonSerializable()
class Offer {
  static final DatabaseReference courseRef =
      FirebaseDatabase.instance.ref().child('courses');
  final Map<Object?, Object?> listOfSessions;
  final String price;
  final String name;
  final String desc;
  final String userID;
  File? _img;

  Offer({
    required this.name,
    required this.listOfSessions,
    required this.price,
    required this.desc,
    required this.userID,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': desc,
        'price': price,
        'session': listOfSessions,
        'userID': userID
      };

  static Future<List<Offer>> getOffers() async {
    DataSnapshot? _snapshot = await courseRef.get();
    List<Offer> _getOffers = [];
    for (DataSnapshot snap in _snapshot.children) {
      late Map<Object?, dynamic> object = snap.value as Map<Object?, dynamic>;
      final course = Offer.fromJson(object);
      _getOffers.add(course);
    }
    return _getOffers;
  }

  File getImage() {
    if (_img!.isAbsolute) {}
    return _img!.absolute;
  }

  set img(File value) {
    _img = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offer &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          userID == other.userID;

  @override
  int get hashCode => name.hashCode ^ userID.hashCode;

  factory Offer.fromJson(dynamic json) => _offerFromJson(json);

  Table previewTable() {
    const double headerSize = 18;
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: <Widget>[
          const TableCell(
              child: Text(
            'Name:',
            style: TextStyle(fontSize: headerSize, fontWeight: FontWeight.bold),
          )),
          TableCell(child: Text(name, textAlign: TextAlign.center)),
        ]),
        TableRow(children: <Widget>[
          const TableCell(
              child: Text('Price:',
                  style: TextStyle(
                      fontSize: headerSize, fontWeight: FontWeight.bold))),
          TableCell(
            child: Text(price, textAlign: TextAlign.center),
          ),
        ]),
        TableRow(children: <Widget>[
          const TableCell(
              child: Text('Description:',
                  style: TextStyle(
                      fontSize: headerSize, fontWeight: FontWeight.bold))),
          TableCell(child: Text(desc, textAlign: TextAlign.center)),
        ]),
      ],
    );
  }

  Future<TaskSnapshot> uploadImageToServer(File _img) async {
    final _s = FirebaseStorage.instance
        .ref()
        .child('courseimages/')
        .child(userID) //TODO ändra till sessionID
        .child(name);
    return await _s.putFile(_img);
  }

  Container offerPreview(bool buyOffer, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Divider(
            height: 5,
            thickness: 1,
            color: Colors.greenAccent.withOpacity(0.3),
          ),
          FutureBuilder(
            future: downloadFile(),
            builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('error');
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                  const CircularProgressIndicator();
                  break;
                case ConnectionState.done:
                  return Image.file(
                    snapshot.requireData!,
                    fit: BoxFit.fitHeight,
                  );
              }
              return const Text('error');
            },
          ),
          Divider(
            height: 5,
            color: Colors.greenAccent.withOpacity(0.3),
            thickness: 1,
          ),
          previewTable(),
          Divider(
            height: 5,
            color: Colors.greenAccent.withOpacity(0.3),
            thickness: 1,
          ),
          buyOffer
              ? ElevatedButton(
                  onPressed: () async {
                    User2? _local = await User2.getLocalUser();
                    _local!.assignToCourse(this);
                    Navigator.pop(context);
                  },
                  child: const Text('buy'))
              : Container(),
        ],
      ),
    );
  }

  Future<void> removeOfferPic() async {
    FirebaseStorage.instance
        .ref()
        .child('courseimages/')
        .child(userID) //TODO ändra till sessionID
        .child(name)
        .delete();
  }

  Card offerCard(double _height) {
    final cardSize = _height / 2;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          Divider(
            color: Colors.greenAccent.withOpacity(0.3),
          ),
          FutureBuilder(
            future: downloadFile(),
            builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('error');
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                  const CircularProgressIndicator();
                  break;
                case ConnectionState.done:
                  return SizedBox(
                      height: cardSize,
                      child: Image.file(
                        snapshot.requireData!,
                        fit: BoxFit.fitWidth,
                      ));
              }
              return const Text('error');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(name),
          ),
          Divider(
            color: Colors.greenAccent.withOpacity(0.3),
          ),
          ListTile(
            title: Text(price),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          )
        ],
      ),
    );
  }

  Future<File?> downloadFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final _s = FirebaseStorage.instance
        .ref('courseimages/' + userID) //TODO ändra till sessionID
        .child(name);
    File downloadToFile = File('${appDocDir.path}/$name.jpg');
    _img = downloadToFile;
    await _s.writeToFile(downloadToFile);
    try {
      return downloadToFile;
    } catch (e) {
      return null;
    }
  }
}

Offer _offerFromJson(dynamic json) {
  return Offer(
      name: json['name'],
      price: json['price'],
      listOfSessions: json['session'],
      desc: json['description'],
      userID: json['userID']);
}
