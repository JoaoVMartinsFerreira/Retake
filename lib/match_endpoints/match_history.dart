import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
class MatchHistory{


  Future<void> getMatchHistory() async {
    final url = Uri.parse('https://pd.na.a.pvp.net/match-history/v1/history/$globalPuuid?startIndex=0&endIndex=20&queue');

    final headers = {
       "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };

    try {
      final response = await http.get(url, headers: headers);
      if(response.statusCode == 200){
        print(response.body);
        print('certo');
      }else{
        print('errado');
        print(response.body);
      }
    } catch (e) {
      print(e);
      Exception(e);
    }
  }
}