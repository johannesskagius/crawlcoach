import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crawl coach admin',
            style: TextStyle(color: Colors.greenAccent)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addoffer');
                    },
                    child: const Text('Add Offer')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewOffers');
                    },
                    child: const Text('View my offers')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addsession');
                    },
                    child: const Text('Add Session')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewSessions');
                    },
                    child: const Text('View my offers')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addexercise');
                    },
                    child: const Text('Add exercise')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/viewexercises');
                    },
                    child: const Text('View my exercises')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onValueListen() {}
}

// BarChart _getBarchart(){
//   return BarChart(
//
//   );
// }
