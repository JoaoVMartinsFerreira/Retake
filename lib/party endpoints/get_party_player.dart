import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retake_app/desktop/gettext/get_text.dart';

String globalPartyId = '';
class GetPartyPlayer {

  
  Future<String> getPartyPlayer(String puuid, String bearer, String entitlementsToken) async {
    final getText = GetText();
    getText.getVersion();
    final url =
        Uri.parse('https://glz-br-1.na.a.pvp.net/parties/v1/players/$puuid');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT":entitlementsToken,
      "X-Riot-ClientVersion": globalVersion,
      "Authorization": "Bearer $bearer",   
    };
    
    try {
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        separatePartyId(response.body);
        return response.statusCode.toString();
      } else {
         return response.statusCode.toString();
      }
    } catch (e) {
      return '$e';
    }
  }

  String separatePartyId(String response){
    Map<String, dynamic> jsonMap = json.decode(response);
    globalPartyId = jsonMap['CurrentPartyID'];
    return jsonMap['CurrentPartyID'];
  }

/**
 * Retonra o Id da Sala.
 */
  String getPartyId(){
    return globalPartyId;
  }


}
