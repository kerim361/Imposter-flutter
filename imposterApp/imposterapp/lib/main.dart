import 'package:flutter/material.dart';
import 'menu_screen.dart';

void main() {
  runApp(const ImposterApp());
}

class ImposterApp extends StatelessWidget {
  const ImposterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFD11149),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD11149),
          primary: const Color(0xFFD11149),
          secondary: const Color(0xFFE6C229),
        ),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
