import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
      String id;
      List<String> editableEvents;
      Timestamp lastSync;
      MyUser(this.id, this.editableEvents, this.lastSync);
}