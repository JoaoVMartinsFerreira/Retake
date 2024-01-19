import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/connector.dart';

String globalEntitlementToken = '';

class EntitlementsToken with AuthConnector {
  Future<String> authEntitlements(String token) async {
    final url =
        Uri.parse('https://entitlements.auth.riotgames.com/api/token/v1');

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        separateToken(response.body);
        
        //print(response.body);
        return response.body;
      } else {
        //print('ERRO ENTITLEMENT POST');
        return 'Erro na solicitação: ${response.statusCode}';
      }
    } catch (e) {
      return 'Erro: $e';
    }
  }
// EU SOU MUITO BURRO NÃO SEI DE ONDE TIREI Q TINHA Q FAZER REGEX PRA PEGAR ESSA PORRA
   String separateToken(String response) { 
  //   String token = '';
  //   RegExp regExp = RegExp(r':(.*?)}');
  //   Match? match = regExp.firstMatch(response);

  //   if (match != null) {
  //     String result = match.group(1)!;
  //     token = result;
  //     globalEntitlementToken = result;
  //     return token;
  //   } else {
  //     return '';
  //   }
      Map<String, dynamic> jsonMap = json.decode(response);
      globalEntitlementToken = jsonMap['entitlements_token'];
      return jsonMap['entitlements_token'];
   }

  String getToken(){
    return globalEntitlementToken;
  }
  
}
