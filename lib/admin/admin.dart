
import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crawl coach admin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/addoffer');
            }, child: const Text('Add Offer')),
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
