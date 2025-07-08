import 'package:flutter/material.dart';
import 'dart:math';
import 'word_loader.dart';

class GameScreen extends StatefulWidget {
  final List<String> playerNames;
  final String categoryFile;

  const GameScreen({
    super.key,
    required this.playerNames,
    required this.categoryFile,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> words = [];
  Map<String, String> playerWordMap = {};
  int currentIndex = 0;
  String startingPlayer = '';

  bool wordRevealed = false;   // <== zeigt, ob Spieler sein Wort schon sieht
  bool showReady = false;      // <== zeigt, ob "Spieler XY fängt an" angezeigt wird

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  Future<void> _startGame() async {
    final loadedWords = await loadWordsFromCategory(widget.categoryFile);
    if (loadedWords.isEmpty) {
      throw Exception("Keine Wörter in Datei gefunden.");
    }

    final random = Random();
    final selectedWord = loadedWords[random.nextInt(loadedWords.length)];
    final impostorIndex = random.nextInt(widget.playerNames.length);

    for (int i = 0; i < widget.playerNames.length; i++) {
      final name = widget.playerNames[i];
      playerWordMap[name] = i == impostorIndex ? "IMPOSTER" : selectedWord;
    }

    startingPlayer = widget.playerNames[random.nextInt(widget.playerNames.length)];

    setState(() {
      words = loadedWords;
    });
  }

  void _nextPlayer() {
    if (currentIndex < widget.playerNames.length - 1) {
      setState(() {
        currentIndex++;
        wordRevealed = false;
      });
    } else {
      setState(() {
        wordRevealed = true; // alle fertig, zeige Abschluss
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty || playerWordMap.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = widget.playerNames[currentIndex];
    final word = playerWordMap[name]!;

    bool isLastPlayer = currentIndex == widget.playerNames.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Imposter Game")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!wordRevealed) ...[
              Text("Spieler: $name", style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => wordRevealed = true),
                child: const Text("Wort anzeigen"),
              ),
            ] else if (!isLastPlayer) ...[
              Text(word, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentIndex++;
                    wordRevealed = false;
                  });
                },
                child: const Text("Weitergeben"),
              ),
            ] else if (!showReady) ...[
              Text(word, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showReady = true;
                  });
                },
                child: const Text("Weitergeben"),
              ),
            ] else ...[
              const Text("Alle Spieler haben ihr Wort!", style: TextStyle(fontSize: 22)),
              const SizedBox(height: 20),
              Text("🔔 $startingPlayer fängt an",
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Zurück zum Menü"),
              )
            ],
          ],
        ),
      ),
    );
  }

}
