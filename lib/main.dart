import 'package:flutter/material.dart';
//import 'features/event_setup/widgets/event_setup.dart';
import 'features/event_setup/widgets/event_setup_test1.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}