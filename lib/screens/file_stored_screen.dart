import 'dart:io';

import 'package:flutter/material.dart';
import '../widgets/centered_list.dart';
import '../widgets/icon_badge.dart';

/// Last step of the navigation flow: File Storage Confirmation.
class FileStoredScreen extends StatelessWidget {
  final String path;

  const FileStoredScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final bool inDocuments = path.startsWith('/storage/emulated/0/Documents');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Saved'),
        automaticallyImplyLeading: false,
      ),
      body: CenteredList(
        children: [
          Icon(Icons.check_circle, size: 80, color: Colors.green.shade700),
          const SizedBox(height: 8),
          const Text(
            'Saved Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: IconBadge(Icons.storage),
              title: Text('Saved in SharedPreferences'),
              subtitle: Text('The student was added to the list on this phone.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const IconBadge(Icons.folder),
              title: Text(
                inDocuments
                    ? 'File saved in your Documents folder'
                    : 'Saved in the app folder (Documents was not writable)',
              ),
              subtitle: SelectableText(path),
            ),
          ),
          Card(
            child: ListTile(
              leading: const IconBadge(Icons.description),
              title: const Text('student_info.txt'),
              // Reads the file back to prove it was really created.
              subtitle: FutureBuilder<String>(
                future: File(path).readAsString(),
                builder: (context, snapshot) => Text(
                  snapshot.data ??
                      (snapshot.hasError
                          ? 'Could not read the file.'
                          : 'Reading file...'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            // Go back to the first screen (the dashboard).
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }
}
