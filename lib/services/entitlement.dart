//FAZER O POST DO ENTITLEMENT
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retake_app/services/connector.dart';

class Entitlements with AuthConnector {
  @override
  Future<String> auth() async {
    final url =
        Uri.parse('https://entitlements.auth.riotgames.com/api/token/v1');
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer eyJraWQiOiJzMSIsImFsZyI6IlJTMjU2In0.eyJwcCI6eyJjIjoiYW0ifSwic3ViIjoiMTFlNmRlZTEtYmY1ZC01ZjYwLWIzYzktMDI3NTk3ZDBiYzExIiwic2NwIjpbIm9wZW5pZCJdLCJjbG0iOlsib3BlbmlkIl0sImRhdCI6eyJjIjoidWUxIiwibGlkIjoibHFQci1hQ3NqblU5OW1Fc2t5dzF1QSJ9LCJpc3MiOiJodHRwczpcL1wvYXV0aC5yaW90Z2FtZXMuY29tIiwiZXhwIjoxNjk1MzQ5Mzg4LCJpYXQiOjE2OTUzNDU3ODgsImp0aSI6ImhvOUQxcEt6LWw0IiwiY2lkIjoicGxheS12YWxvcmFudC13ZWItcHJvZCJ9.TyHTQ-HdZgb7DE52-2ICK5xF484TVVJzuJsXueB0hRHK1Q5Tc3iZjxxSlJcIsvCwwWFo3l7cnTFXjFxPbRkgtfhnM2XM1xScLApmh3DoFVfRf7rI-I2FMcpiAU8SNoTUc4h-Rm9uuvFgLCzvDNfpCrzjV-DsPFe5_bBX_Jia3mQ&scope=openid&iss=https%3A%2F%2Fauth.riotgames.com&id_token=eyJraWQiOiJzMSIsInR5cCI6ImlkX3Rva2VuK2p3dCIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoib2liUHhacUFuTHcwNjA1UmlhRzNXUSIsInN1YiI6IjExZTZkZWUxLWJmNWQtNWY2MC1iM2M5LTAyNzU5N2QwYmMxMSIsImF1ZCI6InBsYXktdmFsb3JhbnQtd2ViLXByb2QiLCJhY3IiOiJ1cm46cmlvdDpicm9uemUiLCJhbXIiOlsicGFzc3dvcmQiXSwiaXNzIjoiaHR0cHM6XC9cL2F1dGgucmlvdGdhbWVzLmNvbSIsImV4cCI6MTY5NTQzMjE4OCwibG9jYWxlIjoicHRfQlIiLCJpYXQiOjE2OTUzNDU3ODgsIm5vbmNlIjoiMSJ9.ayh0TNOtJB9ml7v5WQqmkKMHk5x4a3anhB2a-tgnkkYGPx7UP6ygLWDuUYDFkVVQKtSf4BONiBaLuJPTVjQr8aTZWz5GetZe1mwoIULwB5LpJlGyJlb8433C2JU9i7otdwM8N_-dNiypUU328LElEOClJIgggM_3pw3kFcbjXGE&token_type=Bearer&session_state=pE8nZb9xATFsklIkQzhMPAA3Yv7pazmws26h8zb3cII.QrdaJW8CjUuytVeF4Tku_w&expires_in=3600",
    };

    try {
      final response =
          await http.post(Uri.parse(url.toString()), headers: headers);
      return response.body;
    } catch (e) {
      return 'erro!!!';
    }
  }

  Future<String> auth1() async {
    final baseUrl = Uri.parse(
        'https://127.0.0.1:49929/entitlements/v1/token'); // Substitua {port} pelo número da porta real
    const String username = 'riot';
    const String password = 'rnkF2SXHhkf_lC7TuJwttQ';

    final String base64Credentials =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final Map<String, String> headers = {
      'Authorization': base64Credentials,
    };

    try {
      final response = await http.get(
        Uri.parse(baseUrl.toString()),
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
