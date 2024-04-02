import 'package:flutter/material.dart';
import 'package:iocl_app/screens/loginpage.dart';
import 'utils/consts.dart';
import 'screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void isUserLoggedIn() {
    currentUser = FirebaseAuth.instance.currentUser;
  }
  @override
  void initState() {

    super.initState();
    isUserLoggedIn();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOCL',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: currentUser != null ? const MyHomePage() : const LoginPage(),
    );
  }
}

