import 'package:flutter/material.dart';
import 'package:retake_app/auth/auth_request.dart';
import 'package:retake_app/custom%20widgets/footer_menu_bar.dart';
import 'package:retake_app/menu/main_menu.dart';
import 'package:retake_app/party%20endpoints/start_queue_game.dart';

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