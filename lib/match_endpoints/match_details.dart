import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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
  List<_CharData> agentsData = [];
  Map<String, int> sortedAgents = {};
  List<String> agentsName = [];
  List<int> agentsApearences = [];

  late final Future data;
  @override
  void initState() {
    super.initState();
    clear();
    data = getMatchesIds(); 
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
        getStats(response.body);
        getMatchesIds();
      } 
    } catch (e) {
      Exception(e);
    }
  }

  void agentSum(String agent) {
    if (agentsCount.containsKey(agent)) {
      agentsCount[agent] = agentsCount[agent]! + 1;
    }
  }

  void sortMap() {
    var values = agentsCount.entries.toList();

    values.sort(((a, b) => b.value.compareTo(a.value)));

    sortedAgents = Map<String, int>.fromEntries(values.take(3));
    agentsCount = Map<String, int>.fromEntries(values);
  }

  void getStats(String response) {
    Map<String, dynamic> jsonMap = json.decode(response);
    String characterId = '';
    List<dynamic> players = jsonMap['players'];
    for (var player in players) {
      if (player['gameName'] == 'Deoguinho') {
        characterId = agents[player['characterId']];
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
    for (var element in matchHistory.historyIds) {
      await getMatchDeatilsLoop(element);
    }
    await saveData();
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
          getStats(response.body);
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
    agentsData = [];
    agentsApearences = [];
    agentsCount.forEach((key, value) {
      agentsCount[key] = 0;
    });
  }

  Future<void> saveData() async {
    needReload = false;
    sortMap();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('needReload', needReload);
    await prefs.setStringList('stats',
        <String>[kills.toString(), deaths.toString(), assists.toString()]);
    savedStats = prefs.getStringList('stats');

    statsData = [
      _CharData('ABATES', kills.toInt()),
      _CharData('MORTES', deaths.toInt()),
      _CharData('ASSISTÊNCIAS', assists.toInt()),
    ];


    for (var element in sortedAgents.entries) {
      agentsName.add(element.key);
      agentsApearences.add(element.value);
    }
    agentsData = [
      _CharData(agentsName[0], agentsApearences[0]),
      _CharData(agentsName[1], agentsApearences[1]),
      _CharData(agentsName[2], agentsApearences[2])
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                child: ListView(
                  children:[
                    StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        SfCircularChart(
                          title: ChartTitle(
                            text: 'ESTATISTICAS',
                            textStyle: TextStyle(
                                fontFamily: 'TungstenBold',
                                color: textColors["textBlue"],
                                fontSize: 40),
                          ),
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              textStyle: TextStyle(
                                  color: textColors["textBlue"],
                                  fontFamily: 'TungstenBold',
                                  fontSize: 20)),
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
                        // ElevatedButton(
                        //     onPressed: () async {
                        //       saveData();
                        //     },
                        //     child: const Text('SALVAR')),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       teste();
                        //     },
                        //     child: const Text('EXIBIR GRÁFICO')
                        //     ),
                             SfCartesianChart(
                              primaryXAxis: const CategoryAxis(),
                              primaryYAxis: const NumericAxis(minimum: 0,maximum: 20, interval: 3,),
                          title: ChartTitle(
                            text: 'AGENTES MAIS JOGADOS',
                            textStyle: TextStyle(
                                fontFamily: 'TungstenBold',
                                color: textColors["textBlue"],
                                fontSize: 40),
                          ),
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: TextStyle(
                                  color: textColors["textBlue"],
                                  fontFamily: 'TungstenBold',
                                  fontSize: 20)),
                          series: <CartesianSeries<_CharData, String>>[
                            BarSeries<_CharData, String>(
                              dataSource: agentsData,
                              xValueMapper: (_CharData charData, _) => charData.x,
                              yValueMapper: (_CharData charData, _) => charData.y,
                              name: '',
                              color: Colors.amber,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            )
                          ],
                        ),
                      ],
                    );
                  })
                  ] 
                ),
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
