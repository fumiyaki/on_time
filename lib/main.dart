import 'package:flutter/material.dart';
import 'feature/home/home.dart';
import 'feature/schedule/schedule.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: EventCards(),
      ),
      routes: <String, WidgetBuilder> {
//        SchedulePage.routeName: (context) => SchedulePage()
      }
    );
  }
}
