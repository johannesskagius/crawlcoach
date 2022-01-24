import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: _height,
        width: _width,
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: _height,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: _height*0.2,
                    width: _width*.8,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Today is your opportunity to build the tomorrow you want',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height*0.2,
                    width: _width*.8,
                    child: ElevatedButton(onPressed: (){
                      Navigator.pushNamed(context, '/session');
                    }, child: const Text('Session'),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
