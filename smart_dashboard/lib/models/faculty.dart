/// Challenge 1 - static mock data for the LPU Faculty Directory.
class Faculty {
  final String name;
  final String email;
  final String department;
  final String contact;

  const Faculty({
    required this.name,
    required this.email,
    required this.department,
    required this.contact,
  });
}

const String _ccs = 'College of Information Technology and Computer Science';

const List<Faculty> facultyList = [
  Faculty(
    name: 'Prof. Jeric Bryan Lim',
    email: 'jeric.lim@lpu.edu.ph',
    department: _ccs,
    contact: '0917-123-4567',
  ),
  Faculty(
    name: 'Prof. Edison S. De Los Santos',
    email: 'edison.delossantos@lpu.edu.ph',
    department: _ccs,
    contact: '0918-234-5678',
  ),
  Faculty(
    name: 'Prof. Sean Charlston D. Gono',
    email: 'sean.gono@lpu.edu.ph',
    department: _ccs,
    contact: '0920-345-6789',
  ),
  Faculty(
    name: 'Dr. Amanda Jane C. Menta',
    email: 'amanda.menta@lpu.edu.ph',
    department: _ccs,
    contact: '0927-456-7890',
  ),
  Faculty(
    name: 'Prof. Axel Gabriel Cabarles',
    email: 'axel.cabarles@lpu.edu.ph',
    department: _ccs,
    contact: '0939-567-8901',
  ),
];
