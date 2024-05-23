import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/const/colors.dart';
import 'package:retake_app/custom%20widgets/countdown_timer.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';

Map<String, dynamic> globalOffers = {};
List<String> globalUrls = [];
List<String> globalDisplayNames = [];
List<String> globalSkinsUUid = [];
List<String> globalCosts = [];
List<String> globalTiers = [];
List<Color> globalCardTierColor = [];
int globalOfferTimer = 0;


class Prices extends StatelessWidget {
  const Prices({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getPrices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/market_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SafeArea(
                  child: Text(
                    'OFERTAS',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'TungstenThin',
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                const CountDownTimer(),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: globalUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200.0,
                        height: 300.0,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          color: Colors
                              .transparent, // Torna o fundo do Card transparente para ver o gradiente
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Borda arredondada
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    globalCardTierColor[index],
                                  ]),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    globalUrls[index],
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text('Failed to load image'),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.0,
                                  left: 10.0,
                                  child: Text(
                                    globalDisplayNames[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 30.0,
                                  left: 10.0,
                                  child: Text(
                                    globalCosts[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
              ],
            ),
          );
        }
      },
    );
  }

  Future<String> getPrices() async {
    final url =
        Uri.parse('https://pd.na.a.pvp.net/store/v2/storefront/$globalPuuid');

    final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",
      "X-Riot-ClientPlatform": "ew0KCSJwbGF0Zm9ybVR5cGUiOiAiUEMiLA0KCSJwbGF0Zm9ybU9TIjogIldpbmRvd3MiLA0KCSJwbGF0Zm9ybU9TVmVyc2lvbiI6ICIxMC4wLjE5MDQyLjEuMjU2LjY0Yml0IiwNCgkicGxhdGZvcm1DaGlwc2V0IjogIlVua25vd24iDQp9",
      "X-Riot-ClientVersion": globalVersion,
      
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        getSingleOffers(response.body);
        await getDisplayName();
        await getTier();
        await setTierColors();
        return 'sucesso';
      } else {
        return 'erro';
      }
    } catch (e) {
      return 'erro catch $e';
    }
  }

  void getSingleOffers(String response) {
    Map<String, dynamic> jsonResponse = json.decode(response);
    globalOffers = jsonResponse['SkinsPanelLayout'];
    List<dynamic> singleItemOffers = globalOffers['SingleItemOffers'];
    List<dynamic> storeOffers = globalOffers['SingleItemStoreOffers'];

    for (int i = 0; i < singleItemOffers.length && i <= 4; i++) {
      globalUrls.add(
        'https://media.valorant-api.com/weaponskinlevels/${singleItemOffers[i]}/displayicon.png',
      );
      globalSkinsUUid.add('${singleItemOffers[i]}');
      globalCosts.add(storeOffers[i]['Cost']
              ['85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741']
          .toString());
      storeOffers[i]['Cost']['85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741'];
    }
  }

  Future<void> getTier() async {
    int count = 0;
    var url = Uri.parse('https://valorant-api.com/v1/weapons/skins');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> data = jsonData['data'];
        for (var i = 0; i < data.length; i++) {
          if (count == 4) {
            break;
          }
          if (data[i]['displayName'] == globalDisplayNames[count]) {
            globalTiers.add(data[i]['contentTierUuid']);
            count++;
            i = 0;
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> setTierColors() async {
    try {
      for (var tier in globalTiers) {
        if (tierColors.length == 4) {
          break;
        }
        if (tierColors.containsKey(tier)) {
          globalCardTierColor.add(tierColors[tier]);
        
        }
      }
    } catch (e) {
      print('error');
    }
  }

  Future getDisplayName() async {
    int count = 0;
    List<dynamic> levels = [];
    List<dynamic> data = [];
    Map<String, dynamic> jsonResponse = {};
    var url = Uri.parse('https://valorant-api.com/v1/weapons/skins');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data')) {
          data = jsonResponse['data'];
          for (var item in data) {
            if (item.containsKey('levels')) {
              levels.addAll(item['levels']);
            }
            for (var level in levels) {
              if (level['uuid'] == globalSkinsUUid[count]) {
                globalDisplayNames.add(level['displayName']);
                count++;
              }
            }
          }
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void clear() {
    globalOffers = {};
    globalUrls = [];
    globalDisplayNames = [];
    globalSkinsUUid = [];
    globalCosts = [];
    globalTiers = [];
    globalCardTierColor = [];
    globalOfferTimer = 0;
  }
}
