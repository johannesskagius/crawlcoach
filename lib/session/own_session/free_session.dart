import 'package:flutter/material.dart';

import 'own_sess_add_ex.dart';
import 'own_sess_sum.dart';

class FreeSession extends StatefulWidget {
  const FreeSession({Key? key}) : super(key: key);

  @override
  _FreeSessionState createState() => _FreeSessionState();
}

class _FreeSessionState extends State<FreeSession> {
  final _controller = PageController();

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
          children: const [
            AddExercises(),
            OverView(),
          ],
        ),
        bottomNavigationBar: Row(),
      ),
    );
  }
}
