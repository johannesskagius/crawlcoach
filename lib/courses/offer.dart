import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

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

  Table previewTable(double _width, double _height) {
    const double headerSize = 18;
    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(_width * 0.35),
        1: const FlexColumnWidth(),
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
          TableCell(child: Text(name)),
        ]),
        TableRow(children: <Widget>[
          const TableCell(
              child: Text('Price:',
                  style: TextStyle(
                      fontSize: headerSize, fontWeight: FontWeight.bold))),
          TableCell(
            child: Text(price),
          ),
        ]),
        TableRow(children: <Widget>[
          const TableCell(
              child: Text('Description:',
                  style: TextStyle(
                      fontSize: headerSize, fontWeight: FontWeight.bold))),
          TableCell(child: Text(desc)),
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

  Card offerCard(double _height) {
    final cardSize = _height / 4;
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
          const Divider(),
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
                        fit: BoxFit.fitHeight,
                      ));
              }
              return const Text('error');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(name),
          ),
          const Divider(),
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
