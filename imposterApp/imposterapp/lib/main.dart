import 'package:flutter/material.dart';
import 'menu_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MenuScreen(), // ✅ korrekt: kein Argument übergeben
  ));
}
