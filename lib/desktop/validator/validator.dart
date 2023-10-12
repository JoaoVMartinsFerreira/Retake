import 'dart:io';
import 'package:flutter/material.dart';

class Validator extends StatelessWidget {
  const Validator({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: validator(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Text(snapshot.data ?? '');
          }
        });
  }

  Future<String> validator() async {
    if (Platform.isWindows == true) {
      const processName = 'VALORANT';
      final result = await Process.run('tasklist', []);
      final processList = result.stdout.toString();
      if (processList.contains(processName)) {
        return 'Valorant está rodando!';
      } else {
        return 'Valorant não está rodando!';
      }
    } else {
      return '';
    }
  }
}
