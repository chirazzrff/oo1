import 'package:oo/view/teacher/path_to_folder/syllabus_edit_screen.dart';
import 'package:flutter/material.dart';
import 'syllabus_edit_screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  String subjects =
      "- Introduction à la matière\n- Chapitres principaux\n- Travaux pratiques";
  String dates =
      "- Début du cours : 10 Septembre\n- Examen partiel : 5 Novembre\n- Examen final : 20 Décembre";
  String objectives =
      "- Comprendre les concepts de base\n- Appliquer les notions en contexte réel\n- Développer l’esprit critique";
  String evaluation =
      "- 30% contrôle continu\n- 30% projet\n- 40% examen final";

  // Ton dégradé
  final Gradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Future<void> _downloadSyllabus() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '📘 Sujets abordés',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(subjects),
              pw.SizedBox(height: 20),
              pw.Text(
                '📅 Dates importantes',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(dates),
              pw.SizedBox(height: 20),
              pw.Text(
                '🎯 Objectifs du cours',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(objectives),
              pw.SizedBox(height: 20),
              pw.Text(
                '📝 Modalités d’évaluation',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(evaluation),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/syllabus.pdf');
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Syllabus téléchargé à ${file.path}')),
    );
  }

  Future<void> _shareSyllabus() async {
    String syllabusContent = '''
📘 Sujets abordés:
$subjects

📅 Dates importantes:
$dates

🎯 Objectifs du cours:
$objectives

📝 Modalités d’évaluation:
$evaluation
''';

    await Share.share(syllabusContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Syllabus du cours"),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              section("📘 Sujets abordés", subjects),
              section("📅 Dates importantes", dates),
              section("🎯 Objectifs du cours", objectives),
              section("📝 Modalités d'évaluation", evaluation),
              SizedBox(height: 30),
              _buildButton(
                "Gérer le syllabus",
                Icons.edit,
                Colors.orange,
                    () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SyllabusEditScreen(
                        initialSubjects: subjects,
                        initialDates: dates,
                        initialObjectives: objectives,
                        initialEvaluation: evaluation,
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      subjects = result['subjects'] ?? subjects;
                      dates = result['dates'] ?? dates;
                      objectives = result['objectives'] ?? objectives;
                      evaluation = result['evaluation'] ?? evaluation;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              _buildButton(
                "Télécharger le syllabus",
                Icons.download,
                Colors.blue,
                _downloadSyllabus,
              ),
              SizedBox(height: 20),
              _buildButton(
                "Partager le syllabus",
                Icons.share,
                Colors.green,
                _shareSyllabus,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget section(String title, String content) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      String label,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
