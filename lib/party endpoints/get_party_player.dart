import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retake_app/desktop/gettext/get_text.dart';

String globalPartyId = '';

class GetPartyPlayer {
  Future<void> getPartyPlayer(
      String puuid, String bearer, String entitlementsToken) async {
    final getText = GetText();
    getText.getVersion();
    final url =
        Uri.parse('https://glz-br-1.na.a.pvp.net/parties/v1/players/$puuid');

    final Map<String, String> headers = {
      "X-Riot-ClientPlatform":
          "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
      "X-Riot-Entitlements-JWT": entitlementsToken,
      "Authorization": "Bearer $bearer",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        separatePartyId(response.body);
      }
    } catch (e) {
      Exception(e);
    }
  }

  String separatePartyId(String response) {
    Map<String, dynamic> jsonMap = json.decode(response);
    globalPartyId = jsonMap['CurrentPartyID'];
    return jsonMap['CurrentPartyID'];
  }

/**
 * Retonra o Id da Sala.
 */
  String getPartyId() {
    return globalPartyId;
  }
}
