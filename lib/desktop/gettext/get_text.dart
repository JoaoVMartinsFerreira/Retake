import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String globalVersion = '';
List<String> globalLockfile = [];
class GetText {
  Future<String> getLockfileData() async {
    try {
      File file = File('C:/Users/joaov/AppData/Local/Riot Games/Riot Client/Config/lockfile');
      if (await file.exists()) {
        String contents = await file.readAsString();
        globalLockfile = contents.split(':');
        return 'Conteúdo do arquivo:\n$contents';
      } else {
        return 'O arquivo não existe.';
      }
    } catch (e) {
      return 'Erro ao ler o aquivo: $e';
    }
  }

  Future<String> getVersion() async {
    final url = Uri.parse('https://valorant-api.com/v1/version');
    try {
        final response = await http.get(
        url
      );
      if(response.statusCode == 200){
         separateVersion(response.body);
        return response.body;
      }else{
        return 'Erro';
      }
    } catch (e) {
      e;
    }
    return 'Erro';
  }
  String separateVersion(String response) {
    Map<String,dynamic> jsonMap = json.decode(response);
    Map<String, dynamic> jsonData = jsonMap['data'];
    globalVersion = jsonData["riotClientVersion"];
    return jsonData[ "riotClientVersion"];
  }

  String getVersionText(){
    return globalVersion;
  }
}
