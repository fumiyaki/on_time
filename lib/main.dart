import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'feature/home/home.dart';
import 'feature/chat/chat.dart';
import 'common/drawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(SearchBarDemoApp());
}
