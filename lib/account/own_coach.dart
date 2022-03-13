import 'package:flutter/material.dart';

import 'free_session.dart';

class OwnCoach extends StatefulWidget {
  const OwnCoach({Key? key}) : super(key: key);

  @override
  _OwnCoachState createState() => _OwnCoachState();
}

class _OwnCoachState extends State<OwnCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              //Show training calendar
              //
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FreeSession()));
                },
                child: const Text('Start session'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
