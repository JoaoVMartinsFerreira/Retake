import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:retake_app/desktop/gettext/get_text.dart';
class Friends{

  Future<String> getFriends() async{
      // Ignorando a verificação de certificado SSL
  HttpClient client = HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    
    final getPort = GetText();
    await getPort.getLockfileData();
    final port = globalLockfile[2];
    String encoded = "riot:${globalLockfile[3]}";

    print(port);
    print(encoded);
    final url = Uri.parse('https://127.0.0.1:$port/chat/v4/friends');

    final Map<String, String> headers = {
      "Authorization": "Basic ${base64Encode(utf8.encode(encoded))}"
    };

    try {
      final response = await client.getUrl(url);
      headers.forEach((key, value) {
        response.headers.add(key, value);
      });
      final HttpClientResponse request = await response.close();

      if(request.statusCode == HttpStatus.ok){
        final String responseBody = await request.transform(utf8.decoder).join();
        print(responseBody);
        print(headers);
        print(url);
        return responseBody;
      }else{
        print('ERRO else');
        print(request.statusCode);
        return 'ERRO';
      }
    } catch (e) {
      print('ERRO try $e');
      print(url);
      print(headers);
      return '$e';
    } finally{
      client.close();
    }
  }
  
}