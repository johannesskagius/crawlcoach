import 'package:flutter/material.dart';

import 'free_session01.dart';

class FreeSession00 extends StatelessWidget {
  const FreeSession00({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _sendToNext(String _sport) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => FreeSessionGym(_sport)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('What do you want to do?'),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisCount: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: [
                GestureDetector(
                  onTap: () => _sendToNext('Gym'),
                  child: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(8),
                    child: Center(child: const Text('Gym')),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(8),
                    child: const Center(child: Text('Run')),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(8),
                    child: const Center(child: Text('Swim')),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.pink,
                    padding: const EdgeInsets.all(8),
                    child: const Center(child: Text('Yoga')),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.all(8),
                    child: const Center(child: Text('Bike')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
