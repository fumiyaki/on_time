//formのデータを送る

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      home: MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {

  @override
  MyCustomFormState createState() {
    return MyCustomFormState(
    );
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final EventDate = TextEditingController();
  final EventTitle = TextEditingController();
  final EventDetail = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    EventDate.dispose();
    EventTitle.dispose();
    EventDetail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference addevents = FirebaseFirestore.instance.collection('events');

    Future<void> addEvents() {
      // Call the user's CollectionReference to add a new user
      return addevents
          .add({
        'event_date': EventDate.text,
        'event_title': EventTitle.text,
        'event_detail': EventDetail.text
      })
          .then((value) => print("Event Added"))
          .catchError((error) => print("Failed to add event: $error"));
    }

/*  @override
  Widget build(BuildContext context) {
  }*/

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('OnTime'),
      ),
      body: Center(
        child: FocusTraversalGroup(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: EventDate,
                    decoration: const InputDecoration(
                      labelText: 'イベントの日付/開始時間',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: EventTitle,
                    decoration: const InputDecoration(
                      labelText: 'イベントのタイトル',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: EventDetail,
                    decoration: const InputDecoration(
                      labelText: 'イベントの内容',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
/*                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('Processing Data')));
                        }
                      },*/
                      onPressed: addEvents,
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}