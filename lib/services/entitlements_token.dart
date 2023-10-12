import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:retake_app/services/connector.dart';

class EntitlementsToken with AuthConnector {
  String readFile() {
    final arquivo = File(
        "C:/Users/joaov/AppData/Local/Riot Games/Riot Client/Config/lockfile");
    try {
      final texto = arquivo.readAsStringSync();
      return texto;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String> auth() async {
    const String baseUrl =
        'https://127.0.0.1:{port}/entitlements/v1/token'; // Substitua {port} pelo número da porta real
    const String username = 'riot';
    const String password = '{lockfile password}';

    final String base64Credentials =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final Map<String, String> headers = {
      'Authorization': base64Credentials,
    };

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return 'Resposta bem-sucedida: ${response.body}';
      } else {
        return 'Erro na solicitação: ${response.statusCode}';
      }
    } catch (e) {
      return 'Erro: $e';
    }
  }
}
