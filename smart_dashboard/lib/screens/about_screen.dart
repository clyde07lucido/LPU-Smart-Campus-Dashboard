import 'package:flutter/material.dart';
import '../widgets/centered_list.dart';
import '../widgets/icon_badge.dart';

/// Exercise 2 - About LPU page (Mission, Vision, Core Values).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About LPU')),
      body: const CenteredList(
        children: [
          _AboutCard(
            icon: Icons.flag,
            title: 'Mission',
            text: 'Guided by the ideals of Jose P. Laurel, LPU provides '
                'industry-based knowledge and skills and builds God-centered, '
                'nationalistic, environment-conscious and globally competitive '
                'professionals with wholesome values.',
          ),
          _AboutCard(
            icon: Icons.visibility,
            title: 'Vision',
            text: 'An internationally accredited university by 2030, '
                'dedicated to innovation and excellence in the service of '
                'God and country.',
          ),
          _AboutCard(
            icon: Icons.favorite,
            title: 'Core Values',
            text: 'Love of God\n'
                'Perseverance\n'
                'Unity\n'
                'Nationalism\n'
                'Justice\n'
                'Professional Integrity\n'
                'Leadership',
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _AboutCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBadge(icon),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(text, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
