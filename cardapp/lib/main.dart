import 'package:cardapp/screen/signinPage.dart';
import 'package:flutter/material.dart';
import 'package:cardapp/screen/mainPage.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

// import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const mainApp());
}

class mainApp extends StatefulWidget {
  const mainApp({Key? key}) : super(key: key);

  @override
  State<mainApp> createState() => _MainViewState();
}

class _MainViewState extends State<mainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: signinPage());
    // return MaterialApp(home: signinPage());
  }
}
