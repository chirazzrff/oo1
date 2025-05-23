import 'package:flutter/material.dart';

final Gradient backgroundGradient = const LinearGradient(
  colors: [Color(0xFFBBD2C5), Color(0xFF536976)], // doux et éducatif
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class HomeworkScreen extends StatelessWidget {
  const HomeworkScreen({super.key});

  final List<Map<String, String>> homeworkList = const [
    {"subject": "Maths", "task": "Exercice 5 page 23"},
    {"subject": "Physique", "task": "Rédiger un rapport sur l’énergie"},
    {"subject": "Français", "task": "Lecture chapitre 2 + résumé"},
    {"subject": "Histoire", "task": "Réviser la Révolution Française"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Suivi des devoirs",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF345FB4),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: homeworkList.isEmpty
            ? const Center(
          child: Text(
            "Aucun devoir pour le moment.",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: homeworkList.length,
          itemBuilder: (context, index) {
            final item = homeworkList[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE0E7FF),
                  child: const Icon(Icons.assignment, color: Color(0xFF345FB4)),
                ),
                title: Text(
                  item["subject"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item["task"]!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
