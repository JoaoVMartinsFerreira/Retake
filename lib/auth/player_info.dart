import 'dart:convert';
import 'package:http/http.dart' as http;
String globalPuuid = '';

class PlayerInfo {
  Future<String> getPlayerInfo(String token) async {
    final url = Uri.parse('https://auth.riotgames.com/userinfo');
    final Map<String, String> headers = {"Authorization": "Bearer $token"};
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        separatePuuid(response.body);
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'Erro: $e';
    }
  }
  String separatePuuid(String response) {
    Map<String, dynamic> jsonMap = json.decode(response);
    globalPuuid = jsonMap['sub'];
    return jsonMap['sub'];
  }
  String getPuuid(){
    return globalPuuid;
  }
}
