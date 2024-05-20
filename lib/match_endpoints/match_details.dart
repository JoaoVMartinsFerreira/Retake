import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/const/agents.dart';
import 'package:retake_app/const/colors.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
import 'package:retake_app/match_endpoints/match_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MatchDetails extends StatefulWidget {
  const MatchDetails({Key? key}) : super(key: key);

  @override
  MatchDetailsState createState() => MatchDetailsState();
}

num kills = 0;
num deaths = 0;
num assists = 0;
bool needReload = true;

class MatchDetailsState extends State<MatchDetails> {
  List<String> matchIDs = [];
  late List<String>? savedStats = [];
  //late List<String>? savedStats = [];
  List<_CharData> statsData = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> getMatchDeatils() async {
    final url = Uri.parse(
        'https://pd.na.a.pvp.net/match-details/v1/matches/b18576e2-f049-4684-9e98-70216552b21f');

    final headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform":
          "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print('------------------------------------------------------------');
        getStats(response.body);
        getMatchesIds();
      } else {
        print(response.body);
      }
    } catch (e) {}
  }

  void agentSum(String agent){
    if(agentsCount.containsKey(agent)){
      agentsCount[agent] = agentsCount[agent]! + 1;
    }
  }

  Map<String, int> sortMap(Map<String, int> map){
    var values = agentsCount.entries.toList(); 

    values.sort((a,b) =>b.key.compareTo(a.key));
    
    return Map<String, int>.fromEntries(values);
  }
  void getStats(String response) {
    Map<String, dynamic> jsonMap = json.decode(response);
    String characterId = '';
    List<dynamic> players = jsonMap['players'];
    for (var player in players) {
      if (player['gameName'] == 'Deoguinho') {
        print(player['stats']);
        characterId = agents[player['characterId']];
        print(agentsCount[characterId]);
        print(agents[player['characterId']]);
        agentSum(characterId);
        kills += player['stats']['kills'];
        deaths += player['stats']['deaths'];
        assists += player['stats']['assists'];
      }
    }  
  }
  Future<void> getMatchesIds() async {
    MatchHistory matchHistory = MatchHistory();
    await matchHistory.getMatchHistory();

    //print(matchHistory.historyList);
    for (var element in matchHistory.historyIds) {
      await getMatchDeatilsLoop(element);
      print(element);
    }
    print('$kills/$deaths/$assists');
  }

  Future<void> getMatchDeatilsLoop(String matchId) async {
    final url =
        Uri.parse('https://pd.na.a.pvp.net/match-details/v1/matches/$matchId');

    final headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform":
          "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
    };
    await Future.delayed(const Duration(seconds: 3), () async {
      try {
        final response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          print('------------------------------------------------------------');
          getStats(response.body);
        } else {
          print(response.body);
        }
      } catch (e) {
        Exception(e);
      }
    });
  }

  void clear() {
    kills = 0;
    deaths = 0;
    assists = 0;
    //needReload = true;
  }

  Future<void> saveData() async {
    needReload = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('needReload', needReload);
    await prefs.setStringList('stats',
        <String>[kills.toString(), deaths.toString(), assists.toString()]);
    savedStats = prefs.getStringList('stats');
    

      int? dataKills = prefs.getInt('kills');
      int? dataAssists = prefs.getInt('assists');
      int? dataDeaths = prefs.getInt('deaths');
      statsData = [
        _CharData('ABATES', kills.toInt()),
        _CharData('MORTES', deaths.toInt()),
        _CharData('ASSISTÊNCIAS', assists.toInt()),
      ];


      print(dataKills);
      print(dataDeaths);
      print(dataAssists);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getMatchesIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && needReload) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.hasError}'),
          );
        } else {
          return Align(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/market_background.jpg'),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      SfCircularChart(
                        title:  ChartTitle(
                          text: 'ESTATISTICAS',
                          textStyle: TextStyle(
                              fontFamily: 'TungstenBold',
                              color: textColors["textBlue"],
                              fontSize: 40),
                        ),
                        legend:  Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: TextStyle(
                              color: textColors["textBlue"],
                              fontFamily: 'TungstenBold',
                              fontSize: 20
                            )),
                        series: <CircularSeries<_CharData, String>>[
                          PieSeries<_CharData, String>(
                            dataSource: statsData,
                            xValueMapper: (_CharData charData, _) => charData.x,
                            yValueMapper: (_CharData charData, _) => charData.y,
                            name: 'stats',
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            strokeColor: Colors.black12,
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async{
                            saveData();
                          },
                          child: const Text('SALVAR')),
                          ElevatedButton(onPressed: (){
                            setState((){

                            });
                          }, child: const Text('EXIBIR GRÁFICO'))
                    ],
                  );
                }),
              ),
            ),
          );
        }
      },
    );
  }
}

class _CharData {
  _CharData(this.x, this.y);

  final String x;
  final int y;
}
