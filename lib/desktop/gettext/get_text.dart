import 'dart:io';

class GetText {
  Future<String> readFileContent() async {
    try {
      File file = File('C:/Users/joaov/Desktop/Teste.txt');
      if (await file.exists()) {
        String contents = await file.readAsString();
        return 'Conteúdo do arquivo:\n$contents';
      } else {
        return 'O arquivo não exite.';
      }
    } catch (e) {
      return 'Erro ao ler o aquivo: $e';
    }
  }
}
