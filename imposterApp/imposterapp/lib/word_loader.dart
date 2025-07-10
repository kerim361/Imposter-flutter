// lib/word_loader.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'strings.dart'; // für currentLanguage

Future<List<String>> loadCategoryFilesForLanguage() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final prefix = 'assets/$currentLanguage/';
  final categories = <String>{};

  for (final path in manifestMap.keys) {
    if (path.startsWith(prefix) &&
        path.endsWith('.txt') &&
        !path.contains('hint-')) {
      categories.add(path.replaceFirst(prefix, ''));
    }
  }

  return categories.toList();
}
