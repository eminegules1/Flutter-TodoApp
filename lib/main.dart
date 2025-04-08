import 'package:flutter/material.dart';
import 'package:flutter_application_todoapp/screens/home.dart';
import 'package:flutter_application_todoapp/screens/sign_in.dart';
import 'package:flutter_application_todoapp/screens/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/sign-in',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
      },
    );
  }
}
