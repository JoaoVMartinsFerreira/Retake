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
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void onPressed() async {
    setState(() {
      isLoading = true;
    });

    final result = await auth(
      usernameController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
      resultText = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'Nome de Usuário'),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Senha'),
          obscureText: true, // Para ocultar a senha
        ),
        ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: const Text('Realizar Autenticação'),
        ),
        const SizedBox(height: 16),
        if (isLoading) const CircularProgressIndicator() else Text(resultText),
      ],
    );
  }

  Future<String> auth(String username, String password) async {
    final authCookies = AuthCookies();
    final cookies = await authCookies.cookiesAuth();
    final url = Uri.parse('https://auth.riotgames.com/api/v1/authorization');

    final Map<String, String> headers = {
      "cookie": cookies,
      "Content-Type": "application/json",
    };

    final body = {
      "type": "auth",
      "username": username,
      "password": password,
      "remember": true,
      "language": "pt_BR",
    };

    try {
      final response = await http.put(
        Uri.parse(url.toString()),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return 'Sucesso  \n ${response.body}\n$body\n${body['usernamme']}\n${response.statusCode}';
      } else {
        return '${response.statusCode} \n ${response.body}';
      }
    } catch (e) {
      return '$e';
    }
  }
}
