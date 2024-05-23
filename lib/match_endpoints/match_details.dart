import 'dart:convert';

import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/match_endpoints/match_history.dart';

class MatchDetails{
List<String> MatchIds = [];
  Future<void> getMatchDeatils() async {
    final url = Uri.parse('https://pd.na.a.pvp.net/match-details/v1/matches/b18576e2-f049-4684-9e98-70216552b21f');

    final headers = {
       "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };

    try {
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
        print('------------------------------------------------------------');
        separatePartyId(response.body);
      }else{
        print(response.body);
      }
    } catch (e) {
      
    }
  }
  void separatePartyId(String response){
    Map<String, dynamic> jsonMap = json.decode(response);
    List<dynamic> players = jsonMap['players'];
    final stats = players[0]['stats'];
    for (var player in players) {
      if(player['gameName'] == 'MrCaf'){
        print(player['stats']);
        print(player['gameName']);
      }
    }
  }
  void getMatchesIds() async{
    MatchHistory matchHistory = MatchHistory();
    await matchHistory.getMatchHistory();
    for (var id in matchHistory.historyList) {
      print(id['MatchID']);
      
    }
    print(matchHistory.historyList.length);
  }


}