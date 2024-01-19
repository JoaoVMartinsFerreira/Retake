import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:retake_app/auth/player_info.dart';
import 'package:retake_app/party%20endpoints/get_party_player.dart';

class SetMemberReadyButton extends StatefulWidget {
  const SetMemberReadyButton({Key? key}) : super(key:key);

  @override
  SetMemberReady createState() => SetMemberReady();
}

class SetMemberReady extends State<SetMemberReadyButton>{
  bool isLoading = false;
  bool isReady = true;
  String resultText = '';

  @override
  void initState(){
    super.initState();
  }

void onPressed()  async {
  isLoading = true;
  isReady = isReady ? true : false;

  final result =  await setMemberReadyAction(
  isReady
  );

  setState(() {
    isLoading =  false;
    resultText = result;
  });
}

@override
Widget  build(BuildContext context){
  return Scaffold(
    body: Align(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mobile_background.jpg'),
            fit: BoxFit.cover
            ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 31, 33, 38), 
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: const Text('Pronto')
              ),
              if (isLoading) const CircularProgressIndicator() else Text(resultText, style: const TextStyle(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),)
            ],    
          ),
        ),
      ),
    ),
  );
}


  Future<String> setMemberReadyAction(bool setReady) async{
    final url = Uri.parse(
      'https://glz-br-1.na.a.pvp.net/parties/v1/parties/$globalPartyId/members/$globalPuuid/setReady');

      final Map<String, String> headers = {
      "X-Riot-Entitlements-JWT": globalEntitlementToken,
      "Authorization": "Bearer $globalBearerToken",   
    };

    final body = {
      "ready": setReady
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body));
        if(response.statusCode == 200){
          print(response.body);
          return 'sucesso';
        }else{ 
          return 'erro  $response.body';
        }
    } on StackTrace {
      print(StackTrace);
      return 'erro $StackTrace';
    }

  }
}