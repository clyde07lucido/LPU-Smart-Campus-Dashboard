import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../utils/colors.dart';

/// Challenge 2 - CCS Programme Dashboard (Card + ListTile).
class ProgrammesScreen extends StatelessWidget {
  const ProgrammesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lpuRed,
        foregroundColor: lpuWhite,
        title: const Text(
          'CCS Programme Dashboard',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final p in programmes)
            Card(
              child: ListTile(
                leading: const Icon(Icons.school, color: lpuRed),
                title: Text(p.code),
                subtitle: Text('${p.name}\n${p.students} Students'),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
