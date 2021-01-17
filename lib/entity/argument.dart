import 'package:flutter/material.dart';
import 'my_user.dart';
import 'event.dart';

class Argument {
  MyUser user;
  Event event;
  String nextPage;
  Argument({this.user, this.event, this.nextPage});
}