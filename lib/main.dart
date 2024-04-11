import 'package:flutter/material.dart';
import 'package:retake_app/auth/auth_request.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:  AuthRequestButton()
      ),
    );
  }
}