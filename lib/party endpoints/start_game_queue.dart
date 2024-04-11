import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
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
  bool _isLoading = false;
  String _resultText = '';
  bool _queueState = false;
  late bool _isAccessible = false;
  bool _isPLayerFound = false;
  var _snackBar;
  final GlobalKey<StartQueueGame> widgetKey = GlobalKey();
  GetParty _partyInfo = GetParty();
  @override
  void initState() {
    super.initState();
    checkAccessibility();
  }

  void onPressed() async {
    _isLoading = true;
    final result = await _startQueueAction();
    setState(() {
      _isLoading = false;
      _resultText = result;
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
    if (_partyInfo.getAccessibility() == "OPEN") {
      _isAccessible = true;
    } else {
      _isAccessible = false;
    }
  }

  void leaveOnPressed() async {
    _isLoading = true;
    final leaveResult = await _leaveQueueAction();

    setState(() {
      _isLoading = false;
      _resultText = leaveResult;
    });
  }

  void changeAccessibility() async {
    Future<String> partyAcessibility;
    partyAcessibility = _partyInfo.getAccessibility();
    setState(() {
      _isAccessible ? _isAccessible = false : _isAccessible = true;
      _isAccessible ? _setAccessibility('OPEN') : _setAccessibility('CLOSED');
    });
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
                    if (_checkInviteStatus(_isPLayerFound)) {
                      //Navigator.pop(context);
                    } else {
                      _snackBar = const SnackBar(
                          content: Text("Jogador não encontrado"));
                      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
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
                        value: _isAccessible,
                        onChanged: (value) => changeAccessibility(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _accessibilityText(),
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
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: globalMembersUuids.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      height: 100,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () => {_removePlayer(globalMembersUuids[index])},
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : onPressed,
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
                onPressed: _isLoading ? null : leaveOnPressed,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  _resultText,
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

  Future<String> _startQueueAction() async {
    final url = Uri.parse(
        'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/matchmaking/join');
    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        _queueState = true;
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
    };

    try {
      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        _queueState = false;
        return '';
      } else {
        return 'Houve algum problema';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> _removePlayer(String puuid) async {
    final url =
        Uri.parse('https://glz-br-1.na.a.pvp.net/parties/v1/players/$puuid');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
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
        _isPLayerFound = true;
        return true;
      } else {
        _isPLayerFound = false;
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool _checkInviteStatus(bool inviteStatus) {
    return inviteStatus ? true : false;
  }

  String _accessibilityText() {
    return _isAccessible ? "Grupo aberto" : "Grupo Fechado";
  }
}
