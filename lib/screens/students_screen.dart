import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';
import '../widgets/centered_list.dart';
import '../widgets/info_row.dart';
import 'registration_screen.dart';

/// Shows every student saved with SharedPreferences (Exercise 5).
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Map<String, String>> students = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final data = await loadStudents();
    if (mounted) setState(() => students = data);
  }

  Future<void> edit(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            RegistrationScreen(student: students[index], index: index),
      ),
    );
    load();
  }

  Future<void> register() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Students (${students.length})'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: lpuRed,
        foregroundColor: lpuWhite,
        onPressed: register,
        icon: const Icon(Icons.person_add),
        label: const Text('Register'),
      ),
      body: CenteredList(
        children: [
          if (students.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Icon(Icons.groups, size: 70, color: lpuRed),
                  SizedBox(height: 12),
                  Text('No registered students yet.'),
                ],
              ),
            ),
          for (int i = 0; i < students.length; i++)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 16, right: 12),
                leading: CircleAvatar(
                  backgroundColor: lpuRed,
                  foregroundColor: lpuWhite,
                  child: Text(students[i]['Name']![0].toUpperCase()),
                ),
                title: Text(
                  students[i]['Name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(icon: Icons.badge, text: students[i]['ID']!),
                      InfoRow(icon: Icons.school, text: students[i]['Program']!),
                      InfoRow(
                        icon: Icons.calendar_today,
                        text: students[i]['Year']!,
                      ),
                      InfoRow(
                        icon: Icons.email_outlined,
                        text: students[i]['Email']!,
                      ),
                    ],
                  ),
                ),
                trailing: IconButton(
                  tooltip: 'Edit student',
                  icon: const Icon(Icons.edit, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => edit(i),
                ),
              ),
            ),
          const SizedBox(height: 72), // space so the button never covers a card
        ],
      ),
    );
  }
}
