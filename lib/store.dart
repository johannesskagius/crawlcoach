import 'package:flutter/material.dart';

class Store extends StatelessWidget {
  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: 2,
          children: [
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
            Container(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
