import 'package:flutter/material.dart';

class ViewDataScreen extends StatelessWidget {
  static const String routeName = '/viewData';
  const ViewDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _buildHeader("📊 Statistiques"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildStatCard("Nombre d'élèves", "42", Icons.school),
                    const SizedBox(height: 10),
                    _buildStatCard("Présences ce mois", "350", Icons.check_circle_outline),
                    const SizedBox(height: 10),
                    _buildStatCard("Paiements effectués", "39", Icons.credit_score),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF345FB4)),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
        color: Color(0xFF345FB4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
