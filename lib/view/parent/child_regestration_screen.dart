import 'package:flutter/material.dart';
import 'package:oo/view/screens/datesheet_screen/data/datesheet_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChildRegistrationPage extends StatefulWidget {
  @override
  State<ChildRegistrationPage> createState() => _ChildRegistrationPageState();
}

class _ChildRegistrationPageState extends State<ChildRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  // Dégradé de fond
  final Gradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFF8E9EFB), Color(0xFFB8C6DB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text controllers
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final parentNameController = TextEditingController();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final cardholderController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  String? _selectedClass;
  String? _selectedCourse;
  String? _paymentMethod;

  final List<String> classes = ['1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year'];
  final List<String> courses = ['Math', 'Arabic', 'Science', 'French', 'History', 'Islamic Ed'];
  final List<String> paymentMethods = ['Cash', 'Credit Card', 'Bank Transfer'];

  bool get isCardPayment => _paymentMethod == 'Credit Card';

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    parentNameController.dispose();
    phoneController.dispose();
    amountController.dispose();
    cardholderController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> registerChildAndPayment() async {
    final parentId = supabase.auth.currentUser?.id;

    if (parentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Parent non connecté.")),
      );
      return;
    }

    try {
      // 1. Insérer l’enfant
      final childInsert = await supabase.from('children').insert({
        'name': fullNameController.text,
        'date_of_birth': dobController.text,
        'class': _selectedClass,
        'course': _selectedCourse,
        'parent_id': parentId,
      }).select().single();

      final childId = childInsert['id'];

      // 2. Insérer le paiement dans la table pyment
      final paymentInsert = await supabase.from('pyment').insert({
        'pyment_date': dateSheet,
        'child_id': childId,
        'amount': double.parse(amountController.text),
        'method': _paymentMethod,
        'status': 'Pending',
        'created_at': DateTime.now().toIso8601String(),
      });

      if (paymentInsert.error != null) {
        print('Erreur insertion paiement: ${paymentInsert.error!.message}');
        throw Exception(paymentInsert.error!.message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Enregistrement réussi')),
      );
      _formKey.currentState?.reset();
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Échec de l’enregistrement: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Registration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionTitle('👶 Child Info'),
                _buildField(Icons.person, 'Full Name', controller: fullNameController),
                _buildField(Icons.calendar_today, 'Date of Birth', controller: dobController),
                _buildDropdown(Icons.school, 'Select Class', classes, onChanged: (val) => _selectedClass = val),
                _buildDropdown(Icons.book, 'Select Course', courses, onChanged: (val) => _selectedCourse = val),

                _buildSectionTitle('👨‍👩‍👧 Parent Info'),
                _buildField(Icons.person_outline, 'Parent Name', controller: parentNameController),
                _buildField(Icons.phone, 'Phone Number', controller: phoneController, keyboardType: TextInputType.phone),

                _buildSectionTitle('💳 Payment Info'),
                _buildDropdown(Icons.payment, 'Payment Method', paymentMethods, onChanged: (val) {
                  setState(() => _paymentMethod = val);
                }),
                _buildField(Icons.money, 'Amount (DA)', controller: amountController, keyboardType: TextInputType.number),

                if (isCardPayment) ...[
                  _buildField(Icons.credit_card, 'Cardholder Name', controller: cardholderController),
                  _buildField(Icons.credit_card, 'Card Number', controller: cardNumberController, keyboardType: TextInputType.number),
                  _buildField(Icons.date_range, 'Expiry Date (MM/YY)', controller: expiryController),
                  _buildField(Icons.lock, 'CVV', controller: cvvController, keyboardType: TextInputType.number),
                ],

                SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: Icon(Icons.check_circle_outline),
                  label: Text('Submit Registration'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registerChildAndPayment();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(IconData icon, String label,
      {TextInputType keyboardType = TextInputType.text, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown(IconData icon, String label, List<String> items, {Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.black))))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: EdgeInsets.only(top: 24, bottom: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
