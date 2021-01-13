import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String eventTitle;
  Timestamp eventDate;
  String eventDetails;
  Event(this.id, this.eventTitle, this.eventDate, this.eventDetails);
}
