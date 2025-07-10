import 'package:flutter/services.dart' show rootBundle;
import 'strings.dart'; // für currentLanguage

Future<List<MapEntry<String, String>>> loadWordHintPairs(
    String wordFile, String hintFile) async {
  final wordPath = 'assets/$currentLanguage/$wordFile';
  final hintPath = 'assets/$currentLanguage/$hintFile';

  final wordContent = await rootBundle.loadString(wordPath);
  final hintContent = await rootBundle.loadString(hintPath);

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
    throw Exception('Mismatch in word/hint file: $wordFile / $hintFile');
  }

  return List.generate(words.length, (i) => MapEntry(words[i], hints[i]));
}
