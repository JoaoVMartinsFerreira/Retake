import 'dart:convert';
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/desktop/gettext/get_text.dart';
class MatchHistory{

  List<dynamic> historyList = [];
  List<String>  historyIds = [];

  Future<void> getMatchHistory() async {
    final url = Uri.parse('https://pd.na.a.pvp.net/match-history/v1/history/9a29ba60-1fba-53b5-89f4-ae53d3380959?startIndex=0&endIndex=5&queue=competitive');
    final headers = {
       "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };

    try {
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
        separatePartyId(response.body);
      }
    } catch (e) {
      Exception(e);
    }
  }

   void separatePartyId(String response){
    Map<String, dynamic> jsonMap = json.decode(response);
    historyList = jsonMap['History'];
    for (var element in historyList) {
      historyIds.add(element['MatchID'])  ;
    }
  }
}