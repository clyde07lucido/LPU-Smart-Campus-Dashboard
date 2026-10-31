import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../services/storage_service.dart';
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
  // Only used when editing: the saved student and its position in the list.
  final Map<String, String>? student;
  final int? index;

  const RegistrationScreen({super.key, this.student, this.index});

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
  void initState() {
    super.initState();
    // Editing: fill the form with the saved details.
    final s = widget.student;
    if (s != null) {
      nameController.text = s['Name']!;
      idController.text = s['ID']!;
      emailController.text = s['Email']!;
      contactController.text = s['Contact'] == 'N/A' ? '' : s['Contact']!;
      addressController.text = s['Address'] == 'N/A' ? '' : s['Address']!;
      program = s['Program'];
      yearLevel = s['Year'];
    }
  }

  
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
  Future<void> submit() async {
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

    // The saved list can hold many students, so each ID must be unique.
    final students = await loadStudents();
    if (!mounted) return;
        bool duplicate = false;
    for (int i = 0; i < students.length; i++) {
      if (i != widget.index && students[i]['ID'] == idController.text.trim()) {
        duplicate = true;
      }
    }
    if (duplicate) {
      showMessage('This Student ID is already registered.');
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
          editIndex: widget.index,
          
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
      appBar: AppBar(
        title: Text(
          widget.student == null ? 'Student Registration' : 'Edit Student',
        ),
      ),
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
          ElevatedButton(
            onPressed: submit,
            child: const Text('Review & Continue'),
          ),
        ],
      ),
    );
  }
}
