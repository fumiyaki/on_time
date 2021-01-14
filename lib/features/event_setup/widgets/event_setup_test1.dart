//formのデータを送る

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


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

  final EventTitle = TextEditingController();
  final EventDetail = TextEditingController();

  DateTime EventDate = DateTime.now();
  File _imageFile;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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
        'event_date': EventDate.toString(),
        'event_title': EventTitle.text,
        'event_detail': EventDetail.text
      })
          .then((value) => print("Event Added"))
          .catchError((error) => print("Failed to add event: $error"));
    }

    //Future uploadImageToFirebase(BuildContext context) async {
    Future<void> uploadImageToFirebase() async {
      String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('event_images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      //uploadTask.onCompleteをuploadTaskに変更
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: EventDate, // Refer step 1
        firstDate: DateTime(2021),
        lastDate: DateTime(2050),
      );
      if (picked != null && picked != EventDate)
        setState(() {
          EventDate = picked;
        });
    }

    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('OnTime'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${EventDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Text(
                      'イベントの日付を選択',
                      style:
                      TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
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
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: _imageFile != null
                        ? Image.file(_imageFile)
                        : FlatButton(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onPressed: pickImage,
                    ),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: (){addEvents();uploadImageToFirebase();},
                      child: Text(
                        '登録',
                        style:
                        TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
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