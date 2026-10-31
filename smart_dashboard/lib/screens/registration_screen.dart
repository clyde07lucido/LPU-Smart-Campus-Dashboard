import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../utils/colors.dart';
import '../widgets/centered_list.dart';
import '../widgets/section_title.dart';
import 'summary_screen.dart';

/// Shared look for every input on this form.
InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: lpuWhite,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}

/// Part 3 - Student Registration Form.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  String? program;
  String? yearLevel;

  // Program choices come from the existing programmes list.
  final List<String> programOptions = [
    for (final p in programmes) '${p.code} - ${p.name}',
  ];
  final List<String> yearOptions = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  @override
  void dispose() {
    for (final c in [
      nameController,
      idController,
      emailController,
      contactController,
      addressController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Exercise 3 - validation with SnackBar.
  void submit() {
    if (nameController.text.trim().isEmpty ||
        idController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        program == null ||
        yearLevel == null) {
      showMessage('Please fill in all required fields (*).');
      return;
    }

    if (!emailController.text.contains('@')) {
      showMessage('Please enter a valid email address.');
      return;
    }

    // Part 4 - pass the data to the next screen through the constructor.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryScreen(
          studentName: nameController.text.trim(),
          studentId: idController.text.trim(),
          email: emailController.text.trim(),
          program: program!,
          yearLevel: yearLevel!,
          contact: contactController.text.trim(),
          address: addressController.text.trim(),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType? type,
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        decoration: inputDecoration(label, icon),
      ),
    );
  }

  Widget buildDropdown(
    String label,
    IconData icon,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: inputDecoration(label, icon),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            isDense: true,
            hint: const Text('Select one'),
            items: [
              for (final item in items)
                DropdownMenuItem(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: CenteredList(
        children: [
          const SectionTitle('Required Information'),
          const SizedBox(height: 12),
          buildField('Student Name *', Icons.person, nameController),
          buildField('Student ID *', Icons.badge, idController),
          buildField(
            'Email Address *',
            Icons.email,
            emailController,
            type: TextInputType.emailAddress,
          ),
          buildDropdown(
            'Program *',
            Icons.school,
            program,
            programOptions,
            (value) => setState(() => program = value),
          ),
          buildDropdown(
            'Year Level *',
            Icons.calendar_today,
            yearLevel,
            yearOptions,
            (value) => setState(() => yearLevel = value),
          ),
          const SizedBox(height: 8),
          const SectionTitle('Optional Information'),
          const SizedBox(height: 12),
          buildField(
            'Contact Number',
            Icons.phone,
            contactController,
            type: TextInputType.phone,
          ),
          buildField('Address', Icons.home, addressController, lines: 2),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: submit, child: const Text('Submit')),
        ],
      ),
    );
  }
}
