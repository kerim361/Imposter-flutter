import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'strings.dart';

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
  final Color primary = const Color(0xFFD11149);
  final Color secondary = const Color(0xFFE6C229);

  @override
  void initState() {
    super.initState();
    _loadCategoriesFromJson();
  }

  Future<void> _loadCategoriesFromJson() async {
    final lang = currentLanguage;
    final assetPath = 'assets/$lang/words-$lang.json';
    final jsonStr = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> data = json.decode(jsonStr);

    setState(() {
      categories = data.keys.toList();
      isLoading = false;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (selected.length == categories.length) {
        selected.clear();
      } else {
        selected = List.from(categories);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          "📂 ${t('selectCategory')}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Select All / Deselect All box
                  GestureDetector(
                    onTap: _toggleSelectAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: selected.length == categories.length
                            ? secondary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: selected.length == categories.length
                                ? Colors.black
                                : Colors.grey[300]!),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selected.length == categories.length
                                ? t('deselectAll')
                                : t('selectAll'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: selected.length == categories.length
                                  ? Colors.black
                                  : Colors.grey[800],
                            ),
                          ),
                          Icon(
                            selected.length == categories.length
                                ? Icons.check_circle
                                : Icons.check_box_outline_blank,
                            color: selected.length == categories.length
                                ? Colors.black
                                : Colors.grey[800],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = selected.contains(cat);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selected.remove(cat);
                              } else {
                                selected.add(cat);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              color: isSelected ? secondary : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey[300]!),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey[800],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      color: Colors.black)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, selected),
                    icon: const Icon(Icons.done),
                    label: Text(
                      t('confirmReady'),
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
