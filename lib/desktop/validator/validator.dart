import 'dart:io';
import 'package:flutter/material.dart';

bool checkValidator = false;
bool isLoading = false;

class Validator extends StatelessWidget {
  const Validator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Column(
    children: [
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/desktop_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<String>(
                  future: validator(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return Text(snapshot.data ?? '');
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () => validator(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
      
  }

  Future<String> validator() async {
    if (Platform.isWindows == true) {
      const processName = 'VALORANT';
      final result = await Process.run('tasklist', []);
      final processList = result.stdout.toString();
      if (processList.contains(processName)) {
        checkValidator = true;
        isLoading = true;
        return 'Valorant está rodando!';
      } else {
        isLoading = false;
        return 'Valorant não está rodando!';
      }
    } else {
      return '';
    }
  }
}
