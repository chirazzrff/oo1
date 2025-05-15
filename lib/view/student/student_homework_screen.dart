import 'package:flutter/material.dart';

class StudentHomeworkScreen extends StatelessWidget {
  static const String routeName = 'StudentHomeworkScreen';

  final List<Map<String, String>> homeworkList;

  const StudentHomeworkScreen({super.key, required this.homeworkList});

  final Gradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a transparent AppBar to show the gradient behind
      appBar: AppBar(
        title: const Text("Devoirs"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        padding: const EdgeInsets.only(top: kToolbarHeight + 16, left: 16, right: 16, bottom: 16),
        child: ListView.builder(
          itemCount: homeworkList.length,
          itemBuilder: (context, index) {
            final homework = homeworkList[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(homework['subject'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("À faire pour le ${homework['dueDate'] ?? ''}"),
              ),
            );
          },
        ),
      ),
    );
  }
}
