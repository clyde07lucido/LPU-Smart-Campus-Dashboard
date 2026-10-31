import 'package:flutter/material.dart';
import '../models/faculty.dart';
import '../utils/colors.dart';
import '../widgets/info_row.dart';

/// Challenge 1 - LPU Faculty Directory (static mock data).
class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lpuRed,
        foregroundColor: lpuWhite,
        title: const Text(
          'LPU Faculty Directory',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: facultyList.length,
        itemBuilder: (context, index) {
          final f = facultyList[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: lpuRed,
                foregroundColor: lpuWhite,
                child: Text(f.name.split(' ').last[0]),
              ),
              title: Text(
                f.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(icon: Icons.email_outlined, text: f.email),
                    InfoRow(icon: Icons.apartment, text: f.department),
                    InfoRow(icon: Icons.phone_outlined, text: f.contact),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
