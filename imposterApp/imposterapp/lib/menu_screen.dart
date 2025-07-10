import 'package:flutter/material.dart';
import 'category_selection_screen.dart';
import 'game_screen.dart';
import 'strings.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _playerController = TextEditingController();
  final List<String> _players = [];
  List<String> _selectedCategories = [];

  final Color primary = const Color(0xFFD11149);
  final Color secondary = const Color(0xFFE6C229);
  final Color background = const Color(0xFFFFF3E9);

  void _startGame() {
    if (_players.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('needPlayers'))),
      );
      return;
    }
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('needCategories'))),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          playerNames: _players,
          categoryFiles: _selectedCategories,
        ),
      ),
    );
  }

  void _openCategorySelection() async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => const CategorySelectionScreen(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _selectedCategories = result);
    }
  }

  void _changeLanguage(String lang) {
    setState(() {
      currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('🎮 ${t('appTitle')}',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            tooltip: t('language'),
            icon: const Text("🌐", style: TextStyle(fontSize: 22)),
            onSelected: _changeLanguage,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('🇬🇧 English')),
              PopupMenuItem(value: 'de', child: Text('🇩🇪 Deutsch')),
              PopupMenuItem(value: 'es', child: Text('🇪🇸 Español')),
              PopupMenuItem(value: 'fr', child: Text('🇫🇷 Français')),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👥 ${t('addPlayer')}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerController,
                    decoration: InputDecoration(
                      hintText: t('enterPlayerName'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: secondary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final name = _playerController.text.trim();
                    if (name.isNotEmpty && !_players.contains(name)) {
                      setState(() {
                        _players.add(name);
                        _playerController.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add, size: 24),
                )
              ],
            ),
            const SizedBox(height: 16),
            if (_players.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _players.map((player) {
                  return Chip(
                    label: Text(player),
                    backgroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: primary, width: 1),
                    ),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => setState(() => _players.remove(player)),
                  );
                }).toList(),
              ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _openCategorySelection,
              icon: const Icon(Icons.category),
              label: Text(t('selectCategory')),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondary,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedCategories.isNotEmpty)
              Text(
                '✅ ${t('selectedCategories')}: ${_selectedCategories.map((e) => e.replaceAll(".txt", "")).join(", ")}',
                style: const TextStyle(fontSize: 16),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Icon(Icons.play_arrow),
                label: Text(t('startGame')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
