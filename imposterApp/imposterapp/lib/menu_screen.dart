import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _impostorCount = 1;
  bool _hintEnabled = true;

  late SharedPreferences _prefs;

  final Color primary = const Color(0xFFD11149);
  final Color secondary = const Color(0xFFE6C229);
  final Color background = const Color(0xFFFFF3E9);

  final Map<String, String> _languageFlagAssets = {
    'en': 'uk',
    'de': 'germany',
    'es': 'spain',
    'fr': 'france',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _impostorCount = _prefs.getInt('impostorCount') ?? 1;
      _hintEnabled = _prefs.getBool('hintEnabled') ?? true;
      currentLanguage = _prefs.getString('language') ?? currentLanguage;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setInt('impostorCount', _impostorCount);
    await _prefs.setBool('hintEnabled', _hintEnabled);
    await _prefs.setString('language', currentLanguage);
  }

  void _changeLanguage(String lang) {
    setState(() {
      currentLanguage = lang;
    });
  }

  void _startGame() {
    if (_players.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('minPlayers'))),
      );
      return;
    }
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('selectAtLeastOneCategory'))),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          playerNames: _players,
          categoryFiles: _selectedCategories,
          impostorCount: _impostorCount,
          hintEnabled: _hintEnabled,
        ),
      ),
    );
  }

  Future<void> _openCategorySelection() async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => const CategorySelectionScreen()),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _selectedCategories = result);
    }
  }

  void _openSettings() {
    final maxImpostors = _players.length > 1 ? _players.length - 1 : 1;

    // temporäre Kopien für das Modal
    int tempImpostorCount = _impostorCount.clamp(1, maxImpostors);
    bool tempHintEnabled = _hintEnabled;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titel
                    Text(
                      t('settings'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Impostoren-Dropdown
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        t('numberOfImpostors'),
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: DropdownButton<int>(
                        value: tempImpostorCount,
                        onChanged: (v) {
                          if (v != null) setModalState(() => tempImpostorCount = v);
                        },
                        items: List.generate(maxImpostors, (i) => i + 1)
                            .map((n) => DropdownMenuItem(
                                  value: n,
                                  child: Text(
                                    '$n',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ))
                            .toList(),
                        style: TextStyle(fontSize: 20, color: secondary),
                        underline: const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Hint-Switch
                    SwitchListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        t('hintForImpostor'),
                        style: const TextStyle(fontSize: 20),
                      ),
                      value: tempHintEnabled,
                      onChanged: (v) => setModalState(() => tempHintEnabled = v),
                      activeColor: secondary,
                      inactiveThumbColor: Colors.grey,
                      tileColor: Colors.white,
                    ),
                    const SizedBox(height: 32),

                    // Speichern-Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // in den Haupt-State übernehmen
                          setState(() {
                            _impostorCount = tempImpostorCount;
                            _hintEnabled = tempHintEnabled;
                          });
                          _saveSettings();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          t('save'),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final maxImpostors = _players.length > 1 ? _players.length - 1 : 1;
    if (_impostorCount < 1) _impostorCount = 1;
    if (_impostorCount > maxImpostors) _impostorCount = maxImpostors;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        leading: PopupMenuButton<String>(
          tooltip: t('changeLanguage'),
          icon: Image.asset(
            'assets/flags/${_languageFlagAssets[currentLanguage]}.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.language, color: Colors.white),
          ),
          onSelected: (lang) {
            _changeLanguage(lang);
            _saveSettings();
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'en', child: _buildFlagMenuItem('uk', t('English'))),
            PopupMenuItem(value: 'de', child: _buildFlagMenuItem('germany', t('Deutsch'))),
            PopupMenuItem(value: 'es', child: _buildFlagMenuItem('spain', t('Español'))),
            PopupMenuItem(value: 'fr', child: _buildFlagMenuItem('france', t('Français'))),
          ],
        ),
        title: Text('🎮 ${t('appTitle')}', style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 28),
            onPressed: _openSettings,
          ),
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
                      hintText: t('playerName'),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.add, size: 24),
                ),
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openCategorySelection,
                    icon: const Icon(Icons.category),
                    label: Text(t('selectCategory')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_selectedCategories.isNotEmpty)
              Text(
                '✅ ${_selectedCategories.join(', ')}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 28),
            Center(
              child: ElevatedButton.icon(
                onPressed: _startGame,
                icon: const Icon(Icons.play_arrow, size: 28),
                label: Text(t('startGame')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  minimumSize: const Size.fromHeight(64),
                  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagMenuItem(String fileName, String label) {
    return Row(
      children: [
       	Image.asset(
          'assets/flags/$fileName.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.language, size: 24),
        ),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}