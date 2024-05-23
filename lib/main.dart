import 'package:flutter/material.dart';
import 'package:retake_app/auth/auth_request.dart';
import 'package:retake_app/custom%20widgets/radial_bar.dart';
import 'package:retake_app/match_endpoints/match_details.dart';
import 'package:retake_app/match_endpoints/match_history.dart';
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
        body: AuthRequestButton()
      ),
    );
  }
}