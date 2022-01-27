
import 'package:flutter/material.dart';

class First extends StatelessWidget {
  const First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crawl coach admin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/addsession');
            }, child: const Text('Add Session')),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/addexercise');
            }, child: const Text('Add exercise')),
          ],
        ),
      ),
    );
  }
}
