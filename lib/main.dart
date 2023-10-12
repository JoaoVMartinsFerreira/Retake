import 'package:flutter/material.dart';
import 'package:retake_app/desktop/validator/validator.dart';

import 'package:retake_app/services/auth_cookies.dart';
import 'package:retake_app/services/auth_request.dart';
import 'package:retake_app/services/entitlement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Retake'),
        ),
        body: ListView(
          children: const [AuthRequestButton(), Validator()],
        ),
      ),
    );
  }
}
