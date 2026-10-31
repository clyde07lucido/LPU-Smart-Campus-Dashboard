/// Challenges 2 & 3 - CCS programme statistics (static data).
class Programme {
  final String code;
  final String name;
  final int students;

  const Programme(this.code, this.name, this.students);

  /// Starting count + students registered in the app under this programme.
  /// A saved student's Program looks like "BSIT-WM - Web and Mobile ...".
  int totalWith(List<Map<String, String>> registered) {
    return students +
        registered.where((s) => s['Program']!.startsWith(code)).length;
  }
}

const List<Programme> programmes = [
  Programme('BSIT-NS', 'Network and Security', 120),
  Programme('BSIT-WM', 'Web and Mobile Development', 150),
  Programme('BSCS-DS', 'Data Science', 100),
  Programme('BSCS-SE', 'Software Engineering', 90),
];
