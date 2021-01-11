import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnTime',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddEventWidget(),
    );
  }
}

class AddEventWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            // Pressing space in the field will now move to the next field.
            LogicalKeySet(LogicalKeyboardKey.space): const NextFocusIntent(),
          },
          child: FocusTraversalGroup(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 128),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                Form.of(primaryFocus.context).save();
                },
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(const Size(200, 50)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'イベントの日付/開始時間',
                        ),
                        onSaved: (String value) {
                          //print('Value for field $index saved as "$value"');
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(const Size(200, 50)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'イベントのタイトル',
                        ),
                        onSaved: (String value) {
                          //print('Value for field $index saved as "$value"');
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints.tight(const Size(200, 50)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'イベントの内容',
                        ),
                        onSaved: (String value) {
                          //print('Value for field $index saved as "$value"');
                        },
                      ),
                    ),
                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
