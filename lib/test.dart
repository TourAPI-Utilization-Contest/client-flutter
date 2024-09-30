import 'package:flutter/material.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Home Page")),
      drawer: MyDrawer(),
      body: MyDrawer2(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Account'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
      ]),
    );
  }
}

class MyDrawer2 extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Account'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {},
      ),
    ]);
  }
}
