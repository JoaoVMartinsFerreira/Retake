import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/clear/clear.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/local%20endpoints/friends.dart';
import 'package:retake_app/party%20endpoints/get_party_player.dart';
import 'dart:convert';

Map<dynamic, dynamic> globalResponseMap = {};
String globalIDCard = '';
String globalNickName = '';
List<dynamic> globalMembersUuids = [];
List<dynamic> globalMembersCardsUuids = [];
List<dynamic> globalMembersNames = [];
List<String> globalMembersCardsUrls = [];
List<String> globalMembersTitles = [];

class GetParty implements Clear {
  Future<String> getParty() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform":
          "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        getPartyCardInfo(response.body);
        getMemberUuid(response.body);
        getMembersCards(response.body);
        setCardsUrls();
        //getAccessibility();
        //getMembersTitles(response.body);
        await getMembersNickName();
        return response.body;
      } else {
        return 'Erro';
      }
    } catch (e) {
      return '$e';
    }
  }

  Future<String> getAccessibility() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.get(url, headers: headers);
      Map<String, dynamic> accessibity = jsonDecode(response.body);
      print(accessibity[0]["Accessibility"]);
      return accessibity[0]["Accessibility"];
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> getNickName() async {
    final url = Uri.parse('https://pd.na.a.pvp.net/name-service/v2/players');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform":
          "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };
    List<String> nameServiceBody = [globalPuuid];

    try {
      final response = await http.put(url,
          headers: headers, body: jsonEncode(nameServiceBody));
      if (response.statusCode == 200) {
        getGameName(response.body);
      } else {}
    } catch (e) {
      Exception(e);
    }
  }

  void getPartyCardInfo(String response) {
    globalResponseMap = jsonDecode(response);
    List<dynamic> members = globalResponseMap['Members'];
    Map<String, dynamic> member = members[0];
    Map<String, dynamic> playerIdentity = member['PlayerIdentity'];
    globalIDCard = playerIdentity['PlayerCardID'];
  }

  void getGameName(String response) {
    List<dynamic> jsonMap = json.decode(response);
    globalNickName = jsonMap[0]['GameName'];
  }

  void getMembersGameName(String response) {
    List<dynamic> jsonMap = json.decode(response);
    globalMembersNames.add(jsonMap[0]['GameName']);
  }

  String getCardDisplayIcon() {
    return 'https://media.valorant-api.com/playercards/$globalIDCard/displayicon.png';
  }

  void getMembersCards(String response) {
    List<dynamic> members = globalResponseMap['Members'];
    for (var member in members) {
      globalMembersCardsUuids.add(member['PlayerIdentity']['PlayerCardID']);
    }
  }

  void getMemberUuid(String response) {
    List<dynamic> members = globalResponseMap['Members'];
    for (var member in members) {
      globalMembersUuids.add(member['PlayerIdentity']['Subject']);
    }
  }

  // void getMembersTitles(String response){
  //   List<dynamic> members = globalResponseMap['Members'];
  //   for(var member in members){
  //     globalMembersTitles.add(member['PlayerIdentity']['PlayerTitleID']);
  //   }
  // }
  Future<void> getMembersNickName() async {
    final url = Uri.parse('https://pd.na.a.pvp.net/name-service/v2/players');
    final getText = GetText();
    getText.getVersion();

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform":
          "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };

    List<String> nameServiceBody = [];
    for (var uuid in globalMembersUuids) {
      nameServiceBody = [uuid];
      try {
        final response = await http.put(url,
            headers: headers, body: jsonEncode(nameServiceBody));
        if (response.statusCode == 200) {
          getMembersGameName(response.body);
        }
      } catch (e) {
        Exception(e);
      }
    }
  }

  void setCardsUrls() {
    for (var uuid in globalMembersCardsUuids) {
      globalMembersCardsUrls
          .add('https://media.valorant-api.com/playercards/$uuid/wideart.png');
    }
  }

  @override
  void clear() {
    globalResponseMap.clear();
    globalIDCard = '';
    globalNickName = '';
    globalMembersUuids.clear();
    globalMembersCardsUuids.clear();
    globalMembersNames = [];
    globalMembersCardsUrls.clear();
    
  }
}
