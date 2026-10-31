import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _studentsKey = 'students';

// Copy of the saved list (each student is stored as one JSON string).
List<String> _savedList(SharedPreferences prefs) {
  return [...(prefs.getStringList(_studentsKey) ?? <String>[])];
}

/// Part 5 - read every saved student (still there after the app restarts).
Future<List<Map<String, String>>> loadStudents() async {
  final prefs = await SharedPreferences.getInstance();
  return [
    for (final item in _savedList(prefs))
      Map<String, String>.from(jsonDecode(item)),
  ];
}

/// Part 5 - ADD a student to the saved list (older students are kept).
Future<void> saveStudent(Map<String, String> student) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = _savedList(prefs)..add(jsonEncode(student));
  await prefs.setStringList(_studentsKey, saved);
}

/// Replace one saved student with the edited details.
Future<void> updateStudent(int index, Map<String, String> student) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = _savedList(prefs);
  saved[index] = jsonEncode(student);
  await prefs.setStringList(_studentsKey, saved);
}

/// Part 6 - write student_info.txt (all registered students) and return it.
/// It goes to the phone's Documents folder. If that folder cannot be written,
/// the app's own folder is used instead.
Future<File> exportStudentFile() async {
  final students = await loadStudents();

  final blocks = [
    for (final s in students)
      'STUDENT INFORMATION\n\n'
          '${s.entries.map((e) => '${e.key}: ${e.value}').join('\n')}',
  ];
  final text = blocks.join('\n\n----------------------------\n\n');

  try {
    final file = await File('/storage/emulated/0/Documents/student_info.txt')
        .create(recursive: true);
    return await file.writeAsString(text);
  } catch (_) {
    final directory = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    return File('${directory.path}/student_info.txt').writeAsString(text);
  }
}
