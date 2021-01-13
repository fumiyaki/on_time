import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String eventTitle;
  final Timestamp eventDate;
  final String eventDetails;

  Event(this.id, this.eventTitle, this.eventDate, this.eventDetails);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventTitle': eventTitle,
      'eventDate': eventDate,
      'eventDetails': eventDetails
    };
  }
}
