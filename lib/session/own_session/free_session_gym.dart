import 'package:flutter/material.dart';

import 'own_gym_sess.dart';
import 'own_sess_sum.dart';

class FreeSessionGym extends StatefulWidget {
  const FreeSessionGym(this.sport, {Key? key}) : super(key: key);
  final String sport;

  @override
  _FreeSessionGymState createState() => _FreeSessionGymState();
}

class _FreeSessionGymState extends State<FreeSessionGym> {
  final _controller = PageController();

  void _getExercises() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _pageChanged(int value) {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    }

    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Session'),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.filter_1_outlined)),
          ],
        ),
        body: PageView(
          controller: _controller,
          pageSnapping: true,
          onPageChanged: _pageChanged,
          children: [
            AddExercises(widget.sport),
            const OverView(),
          ],
        ),
        bottomNavigationBar: Row(),
      ),
    );
  }
}
