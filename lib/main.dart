import 'package:campusapp/locator.dart';
import 'package:campusapp/pages/home_page.dart';
import 'package:campusapp/pages/landing_page.dart';
import 'package:campusapp/view_model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpLocator();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
       // initialRoute: '/',

        debugShowCheckedModeBanner: false,
        home: LandingPage(),
      ),
    );
  }
}
