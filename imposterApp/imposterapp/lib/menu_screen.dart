import 'package:flutter/material.dart';
import 'dart:math';
import 'hint_data.dart';

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
  List<String> words = [];
  Map<String, String> playerWordMap = {};
  List<String> randomizedOrder = [];
  int currentIndex = 0;
  late String startingPlayer;

  bool wordVisible = false;
  bool showReady = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  Future<void> _startGame() async {
    final random = Random();
    final allWordHintPairs = <MapEntry<String, String>>[];

    for (var file in widget.categoryFiles) {
      final hintFile = 'hint-$file';
      final pairs = await loadWordHintPairs(file, hintFile);
      allWordHintPairs.addAll(pairs);
    }

    if (allWordHintPairs.isEmpty) {
      throw Exception("Keine Wort-Hinweis-Paare in den Kategorien gefunden.");
    }

    randomizedOrder = List.from(widget.playerNames)..shuffle();
    startingPlayer = randomizedOrder[random.nextInt(randomizedOrder.length)];

    final selected = allWordHintPairs[random.nextInt(allWordHintPairs.length)];
    final selectedWord = selected.key;
    final selectedHint = selected.value;

    final impostorIndex = random.nextInt(widget.playerNames.length);

    for (int i = 0; i < widget.playerNames.length; i++) {
      final name = widget.playerNames[i];
      playerWordMap[name] =
          i == impostorIndex ? "🕵️ Hinweis: $selectedHint" : selectedWord;
    }

    setState(() {
      words = allWordHintPairs.map((e) => e.key).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty || playerWordMap.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFD11149),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final name = randomizedOrder[currentIndex];
    final word = playerWordMap[name]!;
    final isImpostor = word.startsWith("🕵️");
    final isLastPlayer = currentIndex == randomizedOrder.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD11149),
        title: const Text("🕹️ Imposter Game",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: showReady
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "✅ Alle Spieler haben ihr Wort!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "🔔 $startingPlayer fängt an",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE6C229),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.home, size: 24),
                      label: const Text(
                        "Zurück zum Menü",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD11149),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("👤 Spieler: $name",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: wordVisible
                          ? Card(
                              key: const ValueKey(true),
                              color: isImpostor
                                  ? const Color(0xFFE6C229)
                                  : Colors.white,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 32),
                                child: Text(
                                  word,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: isImpostor
                                        ? Colors.black
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Card(
                              key: const ValueKey(false),
                              color: const Color(0xFFD11149),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 32),
                                child: Text("🃏 Karte verdeckt",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: Icon(wordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      label: Text(wordVisible ? "Zudecken" : "Aufdecken"),
                      onPressed: () =>
                          setState(() => wordVisible = !wordVisible),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6C229),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Nächster Spieler"),
                      onPressed: () {
                        if (!isLastPlayer) {
                          setState(() {
                            currentIndex++;
                            wordVisible = false;
                          });
                        } else {
                          setState(() {
                            wordVisible = false;
                            showReady = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD11149),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
