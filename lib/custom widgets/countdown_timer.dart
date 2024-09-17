import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({Key? key}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountDownTimer> {
  late int remainingSeconds = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      getTime();
      startTimer();
    });
  }
  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = fromSeconds(remainingSeconds);

    return SafeArea(
        child: Text(
      'Tempo restante: $formattedTime',
      style: const TextStyle(
        fontSize: 25,
        fontFamily: 'TungstenThin',
        color:Color.fromARGB(255, 255, 255, 255),
      ),
    ));
  }

  String fromSeconds(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingseconds = seconds % 3600;
    int minutes = remainingseconds ~/ 60;
    int remainingSecondsFInal = remainingseconds % 60;

    String hourStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (remainingSecondsFInal).toString().padLeft(2, '0');

    return '$hourStr:$minutesStr:$secondsStr';
  }

  Future<int> getTime() async {
    final url =
        Uri.parse('https://pd.na.a.pvp.net/store/v2/storefront/$globalPuuid');

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
        final jsonResponse = json.decode(response.body);
        final skinsPanelLayout = jsonResponse['SkinsPanelLayout'];
        remainingSeconds =
            skinsPanelLayout['SingleItemOffersRemainingDurationInSeconds'];
        return remainingSeconds;
      } else {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao realizar a requisição: $e');
    }
  }
}
