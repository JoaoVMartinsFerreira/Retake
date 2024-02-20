import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/custom%20widgets/diamond_button.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/party%20endpoints/get_party.dart';
import 'package:retake_app/party%20endpoints/get_party_player.dart';

String globalMatchId = '';


class StartQueueGameButton extends StatefulWidget {
  const StartQueueGameButton({Key? key}) : super(key: key);

  @override
  StartQueueGame createState() => StartQueueGame();
}

class StartQueueGame extends State<StartQueueGameButton> {
  bool isLoading = false;
  String resultText = '';
  bool queueState = false;
  bool isAccessible = true;
  int numPlayers = 0;
  GetParty partyInfo = GetParty();
  @override
  void initState() {
    super.initState();
    numPlayers = globalMembersUuids.length;
  }

  void onPressed() async {
    isLoading = true;
    final result = await startQueueAction();
    setState(() {
      isLoading = false;
      resultText = result;
    });
  }

  void preGameQuitOnpressed() async {
    isLoading = true;
    final result = await preGameQuit();
    setState(() {
      isLoading = false;
      resultText = result;
    });
  }

  void leaveOnPressed() async {
    isLoading = true;
    final leaveResult = await leaveQueueAction();

    setState(() {
      isLoading = false;
      resultText = leaveResult;
    });
  }
  
  void changeAccessibility() async {
    setState(() {
      isAccessible ? isAccessible = false : isAccessible = true;
      isAccessible ? setAccessibility('OPEN') : setAccessibility('CLOSED');
    });
  }
  void addPlayer(){
    setState(() {
      numPlayers++;
    });
  }
  void showAddPlayerDiaglog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String playerName = '';

        return AlertDialog(
          
          title: const Text('CONVIDAR', style:TextStyle(fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
          content: TextField(
            onChanged: (value){
              playerName = value;
            },
            decoration: const InputDecoration(hintText: 'BUSCAR', hintStyle: TextStyle(fontWeight: FontWeight.bold),),
          ),
          actions: [
            TextButton(onPressed: (){
              invitePlater(playerName);
              Navigator.of(context).pop();
            }, child: const Text('CONVIDAR')),
            TextButton(onPressed: Navigator.of(context).pop, child: const Text('CANCELAR'),)
          ],
        );
      }
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Align(
    child: Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/market_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: globalMembersUuids.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned.directional(
                          textDirection: TextDirection.ltr,
                          child: Image.network(globalMembersCardsUrls[index]),
                        ),
                        Positioned.fill(
                          left: 300,
                          child: Text(globalMembersNames[index], 
                          style: const TextStyle(backgroundColor: Color.fromARGB(255,235, 238, 178),
                          fontFamily: 'TungstenBold', fontSize: 20, color: Color.fromARGB(255, 31, 33, 38)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 238, 65, 79),
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              fixedSize: const Size(200, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'COMEÇAR',
              style: TextStyle(
                fontFamily: 'TungstenBold',
                fontSize: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          DiamondFAB(
            onPressed: isLoading ? null : leaveOnPressed,
          ),
          if (isLoading)
            const CircularProgressIndicator()
          else
            Text(
              resultText,
              style: const TextStyle(
                backgroundColor: Colors.transparent,
                fontFamily: 'TungstenThin',
                fontSize: 25,
                color: Color.fromARGB(255, 238, 65, 79),
              ),
            ),
            Switch(value: isAccessible, 
            onChanged: (value) => changeAccessibility(),
            ),
            ElevatedButton(onPressed: showAddPlayerDiaglog, 
            child: Text("ADICIONAR JOGADOR"))
        ],
      ),
    ),
  ),
);

  }

  Future<String> startQueueAction() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/matchmaking/join');
    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        queueState = true;
        return 'Na fila';
      } else {
        return 'Houve algum problema';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> leaveQueueAction() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/matchmaking/leave');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        queueState = false;
        return '';
      } else {
        return 'Houve algum problema';
      }
    } catch (e) {
      return e.toString();
    }
  }
 Future<void> setAccessibility(String option) async {
  final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/accessibility');
  final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    final body = {
      "accessibility": option
    };

    try {
    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    if(response.statusCode == 200){
      print("certo");
    }else{
      print(response.body);
    }
    } catch (e) {
     print(e);
    }
    
 }
  Future<String> preGamePlayer() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/pregame/v1/matches/$globalPuuid');
    bool isInPreGame = false;
    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };
    Map<String, dynamic> jsonResponse = {};
    String result = '';
    while (isInPreGame == false) {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          final response = await http.get(url, headers: headers);
          if (response.statusCode == 200) {
            jsonResponse = jsonDecode(response.body);
            globalMatchId = jsonResponse['MatchID'];
            print(response.statusCode);
            print(response.body);
            isInPreGame = true;
            result = 'sucesso';
            return 'sucesso';
          } else {
            print(url);
            print(response.statusCode);
            print(response.body);
          }
        } catch (e) {
          print(e);
        }
      });
    }
    print(globalMatchId);
    return result;
  }
  Future<String> preGameQuit() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/pregame/v1/matches/$globalMatchId');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        print('saiu da partida');
        return 'sucesso';
      } else {
        print('erro');
        print(response.body);
        print(response.statusCode);
        return 'erro';
      }
    } catch (e) {
      print(e);
      return 'erro ao fazer a reuisição';
    }
  }
  Future<bool> invitePlater(String name) async{
    final url = Uri.parse('https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/invites/name/$name/tag/BR1');
    final Map<String,String> headers = {
      "X-Riot-ClientVersion": globalVersion,
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.post(url, headers: headers);
      if(response.statusCode == 200){
        print("certo");
        return true;
      }
      else{
        print(response.statusCode);
        print(response.headers);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }

  }
}
