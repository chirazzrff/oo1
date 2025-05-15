import 'package:flutter/material.dart';

class CahierDeTexteScreen extends StatefulWidget {
  @override
  _CahierDeTexteScreenState createState() => _CahierDeTexteScreenState();
}

class _CahierDeTexteScreenState extends State<CahierDeTexteScreen> {
  final Gradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  List<Map<String, String>> entries = [
    {
      'title': 'Chapitre 1 : Addition',
      'content': 'Contenu : Addition des nombres entiers',
    },
    {
      'title': 'Chapitre 2 : Multiplication',
      'content': 'Contenu : Multiplication des nombres entiers',
    },
  ];

  void _addEntry() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        return AlertDialog(
          title: Text('Ajouter une entrée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Titre'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Contenu'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
            TextButton(
              onPressed: () {
                setState(() {
                  entries.add({
                    'title': titleController.text,
                    'content': contentController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: Text('Ajouter', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _editEntry(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: entries[index]['title']);
        final contentController = TextEditingController(text: entries[index]['content']);
        return AlertDialog(
          title: Text('Modifier l\'entrée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(hintText: 'Titre')),
              SizedBox(height: 10),
              TextField(controller: contentController, decoration: InputDecoration(hintText: 'Contenu')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler')),
            TextButton(
              onPressed: () {
                setState(() {
                  entries[index] = {
                    'title': titleController.text,
                    'content': contentController.text,
                  };
                });
                Navigator.pop(context);
              },
              child: Text('Modifier', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cahier de texte', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight + 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _addEntry,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Ajouter une entrée'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: ListTile(
                      title: Text(entry['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(entry['content']!),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Modifier') _editEntry(index);
                          if (value == 'Supprimer') _deleteEntry(index);
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'Modifier', child: Text('Modifier')),
                          PopupMenuItem(value: 'Supprimer', child: Text('Supprimer')),
                        ],
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
