import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthCookies {
  Future<String> cookiesAuth() async {
    final url = Uri.parse('https://auth.riotgames.com/api/v1/authorization');

    final Map<String,String> headers ={
      "cookie":
          "__cf_bm=oDQS.2ECbJwkSpQKpTsiaI.SO2kmDN1F774RECILSa0-1692456777-0-AcF34mV1pBI4mL4lRtXOlSOclOts83GNQtdJu7BQ6ZG9oJjV6sRr28yLj%2FDovdRI%2B59MX6vvu0H1ITUa2LhWUuo%3D; tdid=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImFkMjYxNTQ2LTIxNGUtNDhhNS1iOGRlLTU0MDMxZTdkOWVjYyIsIm5vbmNlIjoiVnRhSzEwWFhoZUk9IiwiaWF0IjoxNjkyNDU2ODkwfQ.6DDuMqmNyzbd9xysiFeEQhrbTti-gSdm8_QeNG3mnQE; asid=PaxWPjn9Mter6ph0nxnehFL-JQppVmaoV67GhyqnkfU.NHVtBhDgVHU%253D; clid=ue1; authenticator.sid=s%253AzkbRYlHoS03BAfa_woOA6Jt4OqLehE5-.5AAYcs778VG%252FgYbhqmVUagzINksFf%252FoYeR8RMBh8YKk; __cflb=02DiuF5f8B6AZ17QfrKqDdz1Miwah6DWZv4Fa2yPoh9ec",
      "Content-Type": "application/json",
      "User-Agent": "*"
  };

    final body = {
      "client_id": "play-valorant-web-prod",
      "nonce": "1",
      "redirect_uri": "https://playvalorant.com/opt_in",
      "response_type": "token id_token"
    };

    try {
      final response = await http.post(
        Uri.parse(url.toString()),
        body: jsonEncode(body),
        headers: headers,
      );

      var cookies = response.headers['set-cookie'];
      final desiredCookies = _extractDesiredCookieValues(cookies.toString());

      if (response.statusCode == 200) {
        //print(response.statusCode);
        //print(response.body);
        return desiredCookies;
      } else {
        //'${response.statusCode}';
      }
    } catch (e) {
      Exception(e);
  }
    return 'erro!!!!!';
  }

  String _extractDesiredCookieValues(String cookie) {
    List<String> desiredCookies = [];

    RegExp desiredCookiePattern = RegExp(r'(clid|asid|__cf_bm|tdid)=([^;]+)');
    Iterable<Match> matches = desiredCookiePattern.allMatches(cookie);

    for (Match match in matches) {
      desiredCookies.add("${match.group(1)}=${match.group(2)}");
    }

    return desiredCookies.join("; ");
  }

}
