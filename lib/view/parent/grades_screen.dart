import 'package:flutter/material.dart';

final Gradient backgroundGradient = const LinearGradient(
  colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class GradesScreen extends StatelessWidget {
  static const String routeName = 'GradesScreen';
  const GradesScreen({super.key});

  final List<Map<String, dynamic>> grades = const [
    {"subject": "Maths", "grade": 16},
    {"subject": "Physique", "grade": 13},
    {"subject": "Anglais", "grade": 18},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes de l’élève", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8E9EFB),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: grades.length,
          itemBuilder: (context, index) {
            final grade = grades[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo[100],
                  child: const Icon(Icons.grade, color: Colors.indigo),
                ),
                title: Text(
                  grade["subject"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "${grade["grade"]}/20",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
