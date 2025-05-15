import 'package:flutter/material.dart';

class LessonCompensationScreen extends StatefulWidget {
  static String routeName = 'LessonCompensationScreen';

  const LessonCompensationScreen({super.key});

  @override
  _LessonCompensationScreenState createState() => _LessonCompensationScreenState();
}

class _LessonCompensationScreenState extends State<LessonCompensationScreen> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> lessons = [
    {"name": "Maths", "isCompensated": true},
    {"name": "Physique", "isCompensated": false},
    {"name": "Informatique", "isCompensated": true},
    {"name": "Chimie", "isCompensated": false},
  ];
  List<Map<String, dynamic>> filteredLessons = [];

  @override
  void initState() {
    super.initState();
    filteredLessons = lessons;
  }

  void filterLessons(String query) {
    setState(() {
      filteredLessons = lessons
          .where((lesson) =>
          lesson["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Compensation des leçons',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.withOpacity(0.8),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8EAF6), Color(0xFF7986CB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.only(top: kToolbarHeight + 24, left: 16, right: 16),
        child: Column(
          children: [
            // 🔎 Barre de recherche
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Rechercher une leçon",
                  prefixIcon: Icon(Icons.search, color: Colors.indigo),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: filterLessons,
              ),
            ),
            const SizedBox(height: 20),

            // 📜 Liste des leçons
            Expanded(
              child: filteredLessons.isEmpty
                  ? Center(
                child: Text(
                  "Aucune leçon trouvée.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              )
                  : ListView.builder(
                itemCount: filteredLessons.length,
                itemBuilder: (context, index) {
                  final lesson = filteredLessons[index];
                  final isCompensated = lesson["isCompensated"];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(
                        lesson["name"],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isCompensated
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isCompensated ? Icons.check_circle : Icons.cancel,
                          color: isCompensated ? Colors.green : Colors.red,
                          size: 28,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
