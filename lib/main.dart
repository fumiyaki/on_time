import 'package:flutter/material.dart';
import 'features/home/home.dart';
import 'features/schedule/schedule.dart';


void main() => runApp(MyApp());
//void main() => runApp(SearchBarDemoApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'OnTime';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Home(),
//    home: SearchBarDemoHome(),
      routes: <String, WidgetBuilder> {
//        SchedulePage.routeName: (context) => SchedulePage()
      }
    );
  }
}
