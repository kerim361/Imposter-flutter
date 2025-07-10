// lib/word_hint_loader.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'strings.dart';

/// Lädt für eine einzelne Kategorie (z. B. "Travel & Places")
/// aus assets/<lang>/words-<lang>.json alle Wort-Hinweis-Paare.
Future<List<MapEntry<String, String>>> loadWordHintPairs(
    String category) async {
  final lang = currentLanguage;
  final assetPath = 'assets/$lang/words-$lang.json';
  final jsonStr = await rootBundle.loadString(assetPath);
  final Map<String, dynamic> data = json.decode(jsonStr);

  final List<dynamic> list = data[category] as List<dynamic>? ?? [];
  return list
      .map((e) => MapEntry<String, String>(
          e['word'] as String, e['tip'] as String))
      .toList();
}
