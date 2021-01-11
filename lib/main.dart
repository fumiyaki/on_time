import 'package:flutter/material.dart';
//import 'features/event_setup/widgets/event_setup.dart';
import 'features/event_setup/widgets/event_setup_test2.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() {
  runApp(MyApp());
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}