import 'package:cloud_firestore/cloud_firestore.dart';

class User {
      String id;
      List<String> editableEvents;
      Timestamp lastSync;
      User(this.id, this.editableEvents, this.lastSync);
}