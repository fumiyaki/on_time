import 'package:flutter/material.dart';
//import 'features/event_setup/widgets/event_setup.dart';
import 'features/event_setup/widgets/event_setup_test2.dart';
import 'package:firebase_core/firebase_core.dart';

/*void main() {
  runApp(MyApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}