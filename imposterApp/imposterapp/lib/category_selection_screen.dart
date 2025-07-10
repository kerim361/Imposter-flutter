import 'package:flutter/material.dart';
import 'strings.dart';
import 'word_loader.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  List<String> categories = [];
  List<String> selected = [];
  bool isLoading = true;

  final Color background = const Color(0xFFFFF3E9);
  final Color primary = const Color(0xFFfc4607);
  final Color success = const Color(0xFF67b47c);

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final loaded = await loadCategoryFilesForLanguage();
    setState(() {
      categories = loaded;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(t('selectCategory'),
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: categories.map((cat) {
                        final isSelected = selected.contains(cat);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected ? Colors.black : Colors.grey[400]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              cat.replaceAll('.txt', ''),
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check, color: Colors.black)
                                : null,
                            onTap: () {
                              setState(() {
                                isSelected
                                    ? selected.remove(cat)
                                    : selected.add(cat);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, selected),
                    icon: const Icon(Icons.done),
                    label: Text(t('confirmReady')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
