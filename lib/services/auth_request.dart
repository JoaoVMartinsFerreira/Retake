import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/services/auth_cookies.dart';

class AuthRequestButton extends StatefulWidget {
  const AuthRequestButton({Key? key}) : super(key: key);

  @override
  _AuthRequestButtonState createState() => _AuthRequestButtonState();
}

class _AuthRequestButtonState extends State<AuthRequestButton> {
  String resultText = '';
  bool isLoading = false;

  void onPressed() async {
    setState(() {
      isLoading = true;
    });

    final result = await auth();

    setState(() {
      isLoading = false;
      resultText = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: const Text('Realizar Autenticação'),
        ),
        const SizedBox(height: 16),
        if (isLoading) const CircularProgressIndicator() else Text(resultText),
      ],
    );
  }

  Future<String> auth() async {
    final authCookies = AuthCookies();
    final cookies = await authCookies.cookiesAuth();
    final url = Uri.parse('https://auth.riotgames.com/api/v1/authorization');

    final Map<String, String> headers = {
      "cookie": cookies,
      "Content-Type": "application/json",
    };

    final body = {
      "type": "auth",
      "username": "", //implementar a captação do usuário
      "password": "", //implementar a captação da senha
      "remember": true,
      "language": "en_US"
    };

    try {
      final response = await http.put(
        Uri.parse(url.toString()),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return 'Sucesso';
      } else {
        return '${response.statusCode} \n ${response.body}';
      }
    } catch (e) {
      return '$e';
    }
  }
}
