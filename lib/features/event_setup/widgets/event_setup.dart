//formのデータを送る

import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../../common/app_bar.dart';
import '../../../common/drawer.dart';
import '../../../entity/event.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

/*
class EventSetup extends StatelessWidget {
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
*/

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _eventId;
  String _password;
  Uri _viewerURL;
  Uri _editorURL;
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
        'event_detail': EventDetail.text,
        'password': _password
      })
          .then((value) {
            _eventId = value.id;
            print("Event Added");
      })
          .catchError((error) => print("Failed to add event: $error"));
    }

    //Future uploadImageToFirebase(BuildContext context) async {
    Future<void> uploadImageToFirebase() async {
      String fileName = basename(_imageFile.path);
      final path = fileName;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("event_images/" + _eventId + extension(path));
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      //uploadTask.onCompleteをuploadTaskに変更
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
      );
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2020, 1, 1),
        maxTime: DateTime(2100, 12, 31),
          onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            print('confirm $date');
          }, currentTime: DateTime.now(), locale: LocaleType.jp);
      if (picked != null && picked != EventDate)
        setState(() {
          EventDate = picked;
        });
    }

    double screenWidth = MediaQuery.of(context).size.width;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: MyAppBar(_scaffoldKey),
      body: Scaffold(body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    //"${EventDate.toLocal()}".split(' ')[0],
                    "${EventDate.toLocal()}",
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
                      onPressed: (){
                        _makeLinks();
                        addEvents();
                        uploadImageToFirebase();
                        Event _event = Event(
                          id: _eventId,
                          viewerURL: _viewerURL,
                          password: _password
                        );
                        Navigator.pushNamed(context, 'schedule/',
                        arguments: _event);
                        },
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
        drawerEdgeDragWidth: 0,
        drawer: SizedBox(width: 0.8 * screenWidth, child: MyDrawer()),
        key: _scaffoldKey,
      ),
    );
  }

  void _makeLinks() async {
    // 小文字のアルファベットの文字列を作成
    int smallLetterStart = 97;
    int smallLetterCount = 26;

    var alphabetArray = [];
    // 10個のアルファベットがある文字列を作成して、最後にjoinで繋げています
    var rand = new math.Random();
    for (var i = 0; i < 10; i++) {
      // 0-25の乱数を発生させます
      int number = rand.nextInt(smallLetterCount);
      int randomNumber = number + smallLetterStart;
      alphabetArray.add(String.fromCharCode(randomNumber));
    }

    final DynamicLinkParameters viewerParameters = DynamicLinkParameters(
      uriPrefix: 'https://appontime.page.link',
      link: Uri.parse('https://google.com?id=' + _eventId + '&pass=' + _password),
      androidParameters: AndroidParameters(
        packageName: 'com.example.ontime',
//        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.ontime',
//        minimumVersion: '1.0.1',
//        appStoreId: '123456789',
      ),
    );

    _viewerURL = await viewerParameters.buildUrl();
  }

  DynamicLinkParameters getParameters(bool isEditor) {
    String _link = 'https://google.com?id=' + _eventId;
    if (isEditor) {
      _link += '&pass=' + _password;
    }

    return DynamicLinkParameters(
        uriPrefix: 'https://appontime.page.link',
        link: Uri.parse(_link),
          androidParameters: AndroidParameters(
            packageName: 'com.example.ontime',
  //        minimumVersion: 125,
          ),
          iosParameters: IosParameters(
            bundleId: 'com.example.ontime',
    //        minimumVersion: '1.0.1',
    //        appStoreId: '123456789',
          ),
        );
  }
}