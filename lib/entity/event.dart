import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String eventTitle;
  Timestamp eventDate;
  String eventDetails;
  String password;
  Uri viewerURL;
  Uri editorURL;


  Event({this.id, this.eventTitle, this.eventDate, this.eventDetails, this.password, this.viewerURL, this.editorURL});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventTitle': eventTitle,
      'eventDate': eventDate,
      'eventDetails': eventDetails,
      'viewerURL': viewerURL,
      'password': password
    };
  }
}
