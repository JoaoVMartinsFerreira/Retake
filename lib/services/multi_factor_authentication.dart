import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:retake_app/services/connector.dart';

class MultiFactorAuthButton extends StatefulWidget {
  const MultiFactorAuthButton({Key? key}) : super(key: key);

  @override
  _MultiFactorAuth createState() => _MultiFactorAuth();
}

class _MultiFactorAuth extends State<MultiFactorAuthButton> {
  String resultText = '';
  bool isLoading = false;
  late TextEditingController authCodeController;

  @override
  void initState() {
    super.initState();
    authCodeController = TextEditingController();
  }

  void onPressed() async {
    setState(() {
      isLoading = true;
    });

    final result = await authConnector(
      authCodeController.text,
    );

    setState(() {
      isLoading = false;
      resultText = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autenticação de duas etapas'),
        ),
        body: Column(
          children: [
            TextField(
              controller: authCodeController,
              decoration:
                  const InputDecoration(labelText: 'Código de autenticação'),
            ),
            ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                child: const Text('Realizar autenticação')),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Text(resultText)
          ],
        ),
      ),
    );
  }

  Future<String> authConnector(String code) async {
    final url = Uri.parse('https://auth.riotgames.com/api/v1/authorization');

    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final body = {"type": "multifactor", "code": code, "remenberDevice": true};

    try {
      final response =
          await http.put(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return 'Auententicação feita com sucesso!';
      } else {
        return '${response.statusCode} \n ${response.body}';
      }
    } catch (e) {
      return 'Houve algum erro, tente novamente \n $e';
    }
  }
}
