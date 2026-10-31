import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';
import '../widgets/centered_list.dart';
import 'file_stored_screen.dart';

/// Part 4 - receives the form data through its constructor and shows it in Cards.
class SummaryScreen extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String email;
  final String program;
  final String yearLevel;
  final String contact;
  final String address;

  const SummaryScreen({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.email,
    required this.program,
    required this.yearLevel,
    this.contact = '',
    this.address = '',
  });

  // One map feeds both the Cards on screen and the exported text file.
  Map<String, String> get details => {
        'Name': studentName,
        'ID': studentId,
        'Program': program,
        'Year': yearLevel,
        'Email': email,
        'Contact': contact.isEmpty ? 'N/A' : contact,
        'Address': address.isEmpty ? 'N/A' : address,
      };

  // Parts 5 and 6 - save to SharedPreferences, then create student_info.txt.
  Future<void> saveAndExport(BuildContext context) async {
    final lines = details.entries.map((e) => '${e.key}: ${e.value}');
    final text = 'STUDENT INFORMATION\n\n${lines.join('\n')}';

    try {
      await saveStudent(studentName, studentId, program);
      final file = await exportStudentFile(text);

      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FileStoredScreen(path: file.path, content: text),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: CenteredList(
        children: [
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: lpuRed,
              foregroundColor: lpuWhite,
              child: Text(
                studentName[0].toUpperCase(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            studentName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(program, textAlign: TextAlign.center),
          const SizedBox(height: 16),

          // Exercise 4 - every detail in its own Card + ListTile.
          for (final e in details.entries)
            Card(
              child: ListTile(
                title: Text(e.key),
                subtitle: Text(e.value),
              ),
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => saveAndExport(context),
                  child: const Text('Save & Export'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
