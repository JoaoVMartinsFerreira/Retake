import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:retake_app/auth/entitlements_token.dart';
import 'package:retake_app/auth/multi_factor_authentication.dart';
import 'package:http/http.dart' as http;

class Teste{

  void teste() async{
    final url = Uri.parse('https://valorant-api.com/v1/agents/');
    String json = '';

    try {
      final response  = await http.get(url);
      json = response.body;
      getuuid(response.body);
    } catch (e) {
      
    }
  }
  void getuuid(String response){
    Map<String, dynamic> jsonMap = json.decode(response);
    List<dynamic> data = jsonMap['data'];
    for (var element in data) {
      print(element['displayName']);
    }
  }
}