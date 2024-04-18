import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/custom%20widgets/diamond_button.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/match_endpoints/match_history.dart';
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
  late bool isAccessible = false;
  int numPlayers = 0;
  bool isPLayerFound = false;
  var snackBar;
  final GlobalKey<StartQueueGame> widgetKey = GlobalKey();
  GetParty partyInfo = GetParty();
  MatchHistory matchHistory = MatchHistory();
  @override
  void initState() {
    super.initState();
    numPlayers = globalMembersUuids.length;
    checkAccessibility();
  }

  void onPressed() async {
    isLoading = true;
    final result = await startQueueAction();
    setState(() {
      isLoading = false;
      resultText = result;
    });
  }

  // void preGameQuitOnpressed() async {
  //   isLoading = true;
  //   final result = await preGameQuit();
  //   setState(() {
  //     isLoading = false;
  //     resultText = result;
  //   });
  // }
  void checkAccessibility() {
    if (partyInfo.getAccessibility() == "OPEN") {
      isAccessible = true;
    } else {
      isAccessible = false;
    }
  }

  void leaveOnPressed() async {
    isLoading = true;
    final leaveResult = await _leaveQueueAction();

    setState(() {
      isLoading = false;
      resultText = leaveResult;
    });
  }

  void changeAccessibility() async {
    Future<String> partyAcessibility;
    partyAcessibility = partyInfo.getAccessibility();
    setState(() {
      isAccessible ? isAccessible = false : isAccessible = true;
      isAccessible ? _setAccessibility('OPEN') : _setAccessibility('CLOSED');
    });
  }

  void addPlayer() {
    setState(() {
      numPlayers++;
    });
  }

  void removePlayer() {
    setState(() {});
  }
void getparty()async {
  await partyInfo.getParty().then((value) => {
    setState(() {
    })
  });
}
void clear(){
    partyInfo.clear();
  }
  void showAddPlayerDiaglog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String playerName = '';
          return AlertDialog(
            title: const Text(
              'CONVIDAR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: TextField(
              onChanged: (value) {
                playerName = value;
              },
              decoration: const InputDecoration(
                hintText: 'BUSCAR',
                hintStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _invitePlater(playerName);
                    if (checkInviteStatus(isPLayerFound)) {
                      //Navigator.pop(context);
                    } else {
                      snackBar = const SnackBar(
                          content: Text("Jogador não encontrado"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('CONVIDAR')),
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('CANCELAR'),
              )
            ],
          );
        });
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Switch(
                        value: isAccessible,
                        onChanged: (value) => changeAccessibility(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        accessibilityText(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'TungstenThin',
                            fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{
                    clear();
                    getparty();

                  },
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: globalMembersUuids.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200,
                        height: 100,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () => {

                            matchHistory.getMatchHistory()
                            },
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Positioned.directional(
                                  textDirection: TextDirection.ltr,
                                  child: Image.network(
                                      globalMembersCardsUrls[index]),
                                ),
                                Positioned.fill(
                                  left: 230,
                                  child: Text(
                                    globalMembersNames[index],
                                    style: const TextStyle(
                                        backgroundColor:
                                            Color.fromARGB(255, 235, 238, 178),
                                        fontFamily: 'TungstenBold',
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 31, 33, 38)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 65, 79),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  fixedSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'COMEÇAR',
                  textAlign: TextAlign.end,
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
              SizedBox(
                child: ElevatedButton(
                    onPressed: showAddPlayerDiaglog,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    child: const Text("CONVIDAR")),
              ),
              const SizedBox(
                height: 15,
              )
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
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
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
      Exception(e);
      return e.toString();
    }
  }

  Future<String> _leaveQueueAction() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/matchmaking/leave');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
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

  Future<void> removePlater(String puuid) async {
    final url =
        Uri.parse('https://glz-br-1.na.a.pvp.net/parties/v1/players/$puuid');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };
    try {
      final response = await http.delete(url, headers: headers);
    } catch (e) {
      Exception(e);
    }
  }

  Future<void> _setAccessibility(String option) async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/accessibility');
    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };

    final body = {"accessibility": option};

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));
    } catch (e) {
      Exception(e);
    }
  }
 
  Future<bool> _invitePlater(String name) async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/invites/name/$name/tag/BR1');
    final Map<String, String> headers = {
      "X-Riot-ClientVersion": globalVersion,
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        isPLayerFound = true;
        return true;
      } else {
        isPLayerFound = false;
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool checkInviteStatus(bool inviteStatus) {
    return inviteStatus ? true : false;
  }

  String accessibilityText() {
    return isAccessible ? "Grupo aberto" : "Grupo Fechado";
  }
}