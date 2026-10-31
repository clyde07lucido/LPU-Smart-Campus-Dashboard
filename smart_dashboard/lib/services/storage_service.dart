import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Part 5 - save the student's name, ID and program on the device.
Future<void> saveStudent(String name, String id, String program) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('student_name', name);
  await prefs.setString('student_id', id);
  await prefs.setString('program', program);
}

/// Part 5 - read the saved data back (still there after the app restarts).
/// Returns an empty map when nothing has been saved yet.
Future<Map<String, String>> loadStudent() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('student_name');
  if (name == null) return {};

  return {
    'Name': name,
    'Student ID': prefs.getString('student_id') ?? '',
    'Program': prefs.getString('program') ?? '',
  };
}

/// Part 6 - write student_info.txt and return the created file.
/// The external app folder can be opened from a file manager / Device File
/// Explorer; if it is unavailable we fall back to the documents folder.
Future<File> exportStudentFile(String text) async {
  final directory = await getExternalStorageDirectory() ??
      await getApplicationDocumentsDirectory();

  final file = File('${directory.path}/student_info.txt');
  return file.writeAsString(text);
}
