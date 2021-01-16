import 'package:cloud_firestore/cloud_firestore.dart';

class EditableEvent {
  final String id;
  final String title;
  final Timestamp date;

  EditableEvent({this.id, this.title, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }
}
