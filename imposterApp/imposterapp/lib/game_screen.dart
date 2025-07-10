import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'strings.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;
  final List<String> categoryFiles;

  const GameScreen({
    super.key,
    required this.playerNames,
    required this.categoryFiles,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<MapEntry<String, String>> allPairs = [];
  Map<String, String> playerWordMap = {};
  List<String> randomizedOrder = [];
  int currentIndex = 0;
  late String startingPlayer;

  String? impostorName;
  bool showImposter = false;
  bool wordVisible = false;
  bool showReady = false;

  final Color primary = const Color(0xFFD11149);
  final Color secondary = const Color(0xFFE6C229);
  final Color background = const Color(0xFFFFF3E9);

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  Future<void> _startGame() async {
    final random = Random();
    final lang = currentLanguage;
    final path = 'assets/$lang/words-$lang.json';
    final jsonStr = await rootBundle.loadString(path);
    final Map<String, dynamic> data = json.decode(jsonStr);

    final pairs = <MapEntry<String, String>>[];
    for (var category in widget.categoryFiles) {
      final list = data[category] as List<dynamic>?;
      if (list != null) {
        for (var item in list) {
          pairs.add(MapEntry(item['word'] as String, item['tip'] as String));
        }
      }
    }
    if (pairs.isEmpty) {
      throw Exception(t('noWordHintPairs'));
    }
    allPairs = pairs;

    randomizedOrder = List.from(widget.playerNames)..shuffle();
    startingPlayer = randomizedOrder[random.nextInt(randomizedOrder.length)];

    final sel = allPairs[random.nextInt(allPairs.length)];
    final selectedWord = sel.key;
    final selectedHint = sel.value;

    final impostorIndex = random.nextInt(widget.playerNames.length);
    impostorName = widget.playerNames[impostorIndex];

    for (int i = 0; i < widget.playerNames.length; i++) {
      final name = widget.playerNames[i];
      playerWordMap[name] = i == impostorIndex
          ? "🕵️ ${t('imposter')}: $selectedHint"
          : selectedWord;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (allPairs.isEmpty || playerWordMap.isEmpty) {
      return Scaffold(
        backgroundColor: primary,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final name = randomizedOrder[currentIndex];
    final word = playerWordMap[name]!;
    final isImpostor = word.startsWith("🕵️");
    final isLastPlayer = currentIndex == randomizedOrder.length - 1;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text("🕹️ ${t('appTitle')}",
            style: const TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: showReady
              ? _buildReadyScreen()
              : _buildPlayerScreen(name, word, isImpostor, isLastPlayer),
        ),
      ),
    );
  }

  Widget _buildReadyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => setState(() => showImposter = true),
          child: Text(
            t('revealImposter'),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondary,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        if (showImposter && impostorName != null) ...[
          Text(
            "${t('imposterIs')}: $impostorName",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
        Text(
          t('allPlayersReady'),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          "🔔 $startingPlayer ${t('startsFirst')}",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.home, size: 28),
          label: Text(
            t('backToMenu'),
            style: const TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

 Widget _buildPlayerScreen(
  String name,
  String word,
  bool isImpostor,
  bool isLastPlayer,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "👤 ${t('player')}: $name",
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 30),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCardContent(
          isImpostor && wordVisible,
          wordVisible ? word : null,
        ),
      ),
      const SizedBox(height: 40),
      // Sichtbarkeits-Button mit gelbem Icon
      ElevatedButton.icon(
        icon: Icon(
          wordVisible ? Icons.visibility_off : Icons.visibility,
          size: 28,
          color: const Color(0xFFE6C229), // dein Gelb
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            wordVisible ? t('hide') : t('show'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: () => setState(() => wordVisible = !wordVisible),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      const SizedBox(height: 24),
      // Weiter-/Bestätigungs-Button
      ElevatedButton.icon(
        icon: const Icon(Icons.arrow_forward, size: 28),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            isLastPlayer ? t('confirmReady') : t('nextPlayer'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: () {
          if (!isLastPlayer) {
            setState(() {
              currentIndex++;
              wordVisible = false;
            });
          } else {
            setState(() {
              showReady = true;
              wordVisible = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 64),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    ],
  );
}

  Widget _buildCardContent(bool highlight, String? text) {
    // Definiere hier Breite und Höhe für alle Karten
    const cardWidth = 300.0;
    const cardHeight = 200.0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        key: ValueKey(text),
        color: text != null
            ? (highlight ? primary : Colors.white)
            : secondary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Hier das Center: sowohl Text als auch Bild landen genau mittig
          child: Center(
            child: text != null
                // Wort-Fall: Text wird zentriert
                ? Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: highlight ? Colors.white : Colors.black,
                    ),
                  )
                // Bild-Fall: Karte bleibt mittig
                : Image.asset(
                    'assets/imgs/card.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
        ),
      ),
    );
  }




  Widget _buildBigButton({
    required IconData icon,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}