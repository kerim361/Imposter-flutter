import 'package:flutter/services.dart' show rootBundle;

Future<List<MapEntry<String, String>>> loadWordHintPairs(
    String wordFile, String hintFile) async {
  final wordContent = await rootBundle.loadString('assets/$wordFile');
  final hintContent = await rootBundle.loadString('assets/$hintFile');

  final words = wordContent
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  final hints = hintContent
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  if (words.length != hints.length) {
    throw Exception(
        'Fehler: Anzahl der Wörter und Hinweise stimmt nicht überein.');
  }

  return List.generate(words.length, (i) => MapEntry(words[i], hints[i]));
}
