import 'package:flutter/material.dart';
//import 'feature/home/home.dart';
import 'common/drawer.dart';

void main() {
//  runApp(new SearchBarDemoApp());
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Search Bar Demo',
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new Scaffold(
//            drawerEdgeDragWidth: 0,
            drawer: MyDrawer(),
          body: Center(child: Text('this is body'))
        )
    );
  }
}