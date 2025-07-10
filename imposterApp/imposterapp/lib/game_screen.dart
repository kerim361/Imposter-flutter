import 'package:flutter/material.dart';
import 'dart:math';
import 'hint_data.dart';
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
  List<String> words = [];
  Map<String, String> playerWordMap = {};
  List<String> randomizedOrder = [];
  int currentIndex = 0;
  late String startingPlayer;

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
    final allWordHintPairs = <MapEntry<String, String>>[];

    for (var file in widget.categoryFiles) {
      final hintFile = 'hint-$file';
      final pairs = await loadWordHintPairs(file, hintFile);
      allWordHintPairs.addAll(pairs);
    }

    if (allWordHintPairs.isEmpty) {
      throw Exception("No word-hint pairs found in selected categories.");
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
          i == impostorIndex ? "🕵️ ${t('imposter')}: $selectedHint" : selectedWord;
    }

    setState(() {
      words = allWordHintPairs.map((e) => e.key).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty || playerWordMap.isEmpty) {
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
        elevation: 2,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: showReady
                ? _buildReadyScreen()
                : _buildPlayerScreen(name, word, isImpostor, isLastPlayer),
          ),
        ),
      ),
    );
  }

  Widget _buildReadyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t('allPlayersReady'),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          "🔔 $startingPlayer ${t('startsFirst')}",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
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
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerScreen(
      String name, String word, bool isImpostor, bool isLastPlayer) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "👤 ${t('player')}: $name",
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 30),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: wordVisible
              ? _buildCardContent(word, isImpostor, true)
              : _buildCardContent(t('cardHidden'), false, false),
        ),
        const SizedBox(height: 40),
        _buildBigButton(
          icon: wordVisible ? Icons.visibility_off : Icons.visibility,
          text: wordVisible ? t('hide') : t('show'),
          color: primary,
          textColor: Colors.white,
          onPressed: () =>
              setState(() => wordVisible = !wordVisible),
        ),
        const SizedBox(height: 24),
        _buildBigButton(
          icon: Icons.arrow_forward,
          text: isLastPlayer ? t('confirmReady') : t('nextPlayer'),
          color: secondary,
          textColor: Colors.black,
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
        ),
      ],
    );
  }

  Widget _buildCardContent(String text, bool isImpostor, bool visible) {
    return Card(
      key: ValueKey(visible),
      color: visible
          ? (isImpostor ? primary : Colors.white)
          : secondary,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: visible && isImpostor ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
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
        child: Text(
          text,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
