import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';

/// Challenge 2 - CCS Programme Dashboard (Card + ListTile).
/// Counts include the students registered in the app.
class ProgrammesScreen extends StatefulWidget {
  const ProgrammesScreen({super.key});

  @override
  State<ProgrammesScreen> createState() => _ProgrammesScreenState();
}

class _ProgrammesScreenState extends State<ProgrammesScreen> {
  List<Map<String, String>> registered = [];

  @override
  void initState() {
    super.initState();
    loadStudents().then((data) {
      if (mounted) setState(() => registered = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CCS Programme Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final p in programmes)
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: lpuRed),
                title: Text(p.code),
                subtitle: Text('${p.name}\n${p.totalWith(registered)} Students'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
