import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/party%20endpoints/get_party_player.dart';

/**
 * Classe com o método para mudar o tipo de partida
 */
class ChangeQueue {
  /**
   * MÉTODO HTTP PARA MUDAR O TIPO DE PARTIDA.
   * REQUER UM PARÂMETRO DO TIPO String PARA FAZER A REQUISIÇÃO
   */

  Future<void> changeQueue(String queueId) async {
    final url = Uri.parse('https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/queue');
    final getText = GetText();
        getText.getVersion();

    final Map<String, String> headers = {
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    final body = {
      "queueId": queueId
    };

    try {
      final response = await http.post(url, body: jsonEncode(body), headers: headers);
      if(response.statusCode == 200){
        //print(response.body);
      }
      else{
        // print(url);
        // print(response.body);
        // print(response.headers);
        // print("-------------ERRO-------------------------------");
      }
    } catch (e) {
      Exception(e);
    }
  }
}
