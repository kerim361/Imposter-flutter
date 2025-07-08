import 'package:flutter/material.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> categories = ['obst.txt', 'tiere.txt', 'berufe.txt'];
  String selectedCategory = 'obst.txt';

  final List<String> players = [];
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        players.add(name);
        _nameController.clear();
      });
    }
  }

  void _startGame() {
    if (players.length < 3) return; // Mindestanzahl

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          playerNames: players,
          categoryFile: selectedCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imposter Game')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Kategorie auswählen", style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat.replaceAll('.txt', ''))))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            const SizedBox(height: 20),
            const Text("Spieler hinzufügen", style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: _nameController, decoration: const InputDecoration(hintText: "Name")),
                ),
                IconButton(onPressed: _addPlayer, icon: const Icon(Icons.add))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (_, i) => ListTile(title: Text(players[i])),
              ),
            ),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text("Spiel starten"),
            ),
          ],
        ),
      ),
    );
  }
}
