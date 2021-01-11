import 'package:flutter/material.dart';

class LabeledInputWidget extends StatelessWidget {
  final Widget child;
  final String title;

  LabeledInputWidget({
    @required this.child,
    @required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        Row(
          children: [
            SizedBox(width: 16.0),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 8),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: child
        ),
      ],
    );
  }
}