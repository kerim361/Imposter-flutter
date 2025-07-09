import 'package:flutter/material.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<String> categories = ['obst.txt', 'tiere.txt', 'berufe.txt'];
  final List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfc4607),
        title: const Text("Kategorien wählen",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ...categories.map((cat) {
              final isSelected = selected.contains(cat);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade400,
                      width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(cat.replaceAll('.txt', ''),
                      style: const TextStyle(fontSize: 18)),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.black)
                      : null,
                  onTap: () {
                    setState(() {
                      isSelected ? selected.remove(cat) : selected.add(cat);
                    });
                  },
                ),
              );
            }),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, selected),
              icon: const Icon(Icons.done),
              label: const Text("Fertig"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF67b47c),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
