import 'package:flutter/material.dart';
import 'package:ontime/feature/home/home.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() {
  runApp(new SearchBarDemoApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new SearchBarDemoApp());
}
