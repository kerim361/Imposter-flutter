import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> loadWordsFromCategory(String categoryFile) async {
  final content = await rootBundle.loadString('assets/$categoryFile');
  return content.split('\n')
    .map((e) => e.trim())
    .where((e) => e.isNotEmpty)
    .toList();
}
