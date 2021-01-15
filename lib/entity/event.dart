import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String eventTitle;
  Timestamp eventDate;
  String eventDetails;
  Uri viewerURL;
  String password;

  Event({this.id, this.eventTitle, this.eventDate, this.eventDetails, this.viewerURL, this.password});

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
