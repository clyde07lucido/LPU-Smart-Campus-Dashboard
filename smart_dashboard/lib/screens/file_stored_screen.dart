import 'package:flutter/material.dart';
import '../widgets/centered_list.dart';
import '../widgets/icon_badge.dart';

/// Last step of the navigation flow: File Storage Confirmation.
class FileStoredScreen extends StatelessWidget {
  final String path;
  final String content;

  const FileStoredScreen({
    super.key,
    required this.path,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Storage Confirmation'),
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
              title: Text('SharedPreferences'),
              subtitle: Text('Name, ID and Program were saved on this device.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const IconBadge(Icons.folder),
              title: const Text('File Location'),
              subtitle: SelectableText(path),
            ),
          ),
          Card(
            child: ListTile(
              leading: const IconBadge(Icons.description),
              title: const Text('student_info.txt'),
              subtitle: Text(content),
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
