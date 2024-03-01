import 'package:retake_app/auth/auth_request.dart';
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/party%20endpoints/get_party.dart';
import 'package:retake_app/party%20endpoints/get_party_player.dart';

class NoMultifacfor{
final authRequest = AuthRequest();
  /***
   * Método usando quando a conta não requer verificaçãode duas etapas
   */
   Future noMfa() async{
     final entitlements = EntitlementsToken();
    final playerInfo = PlayerInfo();
    final getText = GetText();
    final getPartyPlayer = GetPartyPlayer();
    final getParty = GetParty();
    getText.getVersion();

    try {
       globalBearerToken = globalDirectBearerToken;
        await playerInfo.getPlayerInfo(getBearerToken());
        await entitlements.authEntitlements(getBearerToken());
        await getPartyPlayer.getPartyPlayer(globalPuuid, globalBearerToken, entitlements.getToken());
        await getParty.getPartyAuth();
        await getParty.getNickName();
    } catch (e) {
      print(e);
    }
   }
     String getBearerToken() {
    return globalBearerToken;
  }

}