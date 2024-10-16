import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScrollTestPage(),
    );
  }
}

class ScrollTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scroll Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.blue,
              child: Center(child: Text('Scroll enabled area 1')),
            ),
            Container(
              height: 300,
              child: GestureDetector(
                onVerticalDragUpdate: (_) {},
                child: Container(
                  height: 500,
                  color: Colors.red,
                  child: Center(child: Text('Scroll disabled area')),
                ),
              ),
            ),
            Listener(
              onPointerMove: (event) {
                print('onPointerMove');
                // 스크롤 차단
              },
              child: Container(
                height: 300,
                color: Colors.red,
                child: Center(child: Text('Scroll disabled area')),
              ),
            ),
            Container(
              height: 300,
              color: Colors.green,
              child: Center(child: Text('Scroll enabled area 2')),
            ),
          ],
        ),
      ),
    );
  }
}
