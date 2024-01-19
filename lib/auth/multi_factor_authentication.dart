import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/auth_request.dart';
import 'dart:convert';
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/custom%20widgets/footer_menu_bar.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/party%20endpoints/get_party_player.dart';
import '../party endpoints/get_party.dart';

String globalBearerToken = '';

class MultiFactorAuthButton extends StatefulWidget {
  const MultiFactorAuthButton({Key? key}) : super(key: key);

  @override
  MultiFactorAuth createState() => MultiFactorAuth();
}

class MultiFactorAuth extends State<MultiFactorAuthButton> {
  String resultText = '';
  bool isLoading = false;
  var snackBar;
  late TextEditingController authCodeController;

  @override
  void initState() {
    super.initState();
    authCodeController = TextEditingController();
  }

  void onPressed() async {
    final navigator = Navigator.of(context);
    setState(() {
      isLoading = true;
    });

    final result = await mfaAtuh(
      authCodeController.text,
    );

    setState(() {
      isLoading = false;
      resultText = result;
    });

    if (verifyResponse(result)) {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const FooterMenuBar()));
    } else {
      snackBar = const SnackBar(
          content: Text(
              'Erro na autenticação! \n Verifique seo código está correto conexão com a internet'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mobile_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 450,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: authCodeController,
                  textAlign: TextAlign.justify,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Código',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 31, 33, 38),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )),
                child: const Text('DOIS FATORES',
                    style: TextStyle(
                      fontFamily: 'TungstenBold',
                      fontSize: 20,
                    )),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Text(resultText),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> mfaAtuh(String code) async {
    final url = Uri.parse('https://auth.riotgames.com/api/v1/authorization');
    final authRequest = AuthRequest();
    final entitlements = EntitlementsToken();
    final playerInfo = PlayerInfo();
    final getText = GetText();
    final getPartyPlayer = GetPartyPlayer();
    final getParty = GetParty();
    final cookies = authRequest.getCookies();

    getText.getVersion();

    final Map<String, String> headers = {
      "cookie": cookies,
      "Content-Type": "application/json"
    };

    final body = {"type": "multifactor", "code": code, "rememberDevice": false};

    try {
      final response =
          await http.put(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        globalBearerToken = separateBearerToken(response.body);
        await playerInfo.getPlayerInfo(getBearerToken());
        await entitlements.authEntitlements(getBearerToken());
        await getPartyPlayer.getPartyPlayer(
            globalPuuid, globalBearerToken, entitlements.getToken());
        await getParty.getPartyAuth();
        await getParty.getNickName();
        //await friends.getFriends();
        return 'Auententicação feita com sucesso';
      } else {
        return ' Houve algum erro na atutenticação \n ${response.statusCode}';
      }
    } catch (e) {
      return 'Houve algum erro, tente novamente \n $e';
    }
  }

  String getToken(String token) {
    return token;
  }

  String separateBearerToken(String code) {
    String inputString = code;
    String token = '';

    RegExp regExp = RegExp(r'=(.*?)&');
    Match? match = regExp.firstMatch(inputString);

    if (match != null) {
      String result = match.group(1)!;
      token = result;
      return token;
    } else {
      return '';
    }
  }

  String getBearerToken() {
    return globalBearerToken;
  }

  bool verifyResponse(String response) {
    return response.contains('sucesso') ? true : false;
  }
}
