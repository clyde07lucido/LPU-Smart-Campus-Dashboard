import 'package:flutter/material.dart';
import '../models/programme.dart';
import '../utils/colors.dart';
import '../widgets/api_builder.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_card.dart';

/// Analytics tab:
///  - Challenge 4: summary statistics computed from the API data
///  - Challenge 3: programme statistics in a GridView.count dashboard
class AnalyticsScreen extends StatelessWidget {
  final Future<List<dynamic>> future;
  final VoidCallback onRetry;

  const AnalyticsScreen({
    super.key,
    required this.future,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int columns = width > 600 ? 4 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('API Summary (Live)'),
          ApiBuilder(
            future: future,
            onRetry: onRetry,
            builder: (users) {
              // All values are computed dynamically from the API response.
              final totalUsers = users.length;

              final totalCompanies = users
                  .map((u) => u['company']?['name'])
                  .where((name) => name != null)
                  .toSet()
                  .length;

              final totalEmails = users
                  .where((u) => (u['email'] ?? '').toString().isNotEmpty)
                  .length;

              final totalContacts = users
                  .where((u) => (u['phone'] ?? '').toString().isNotEmpty)
                  .length;

              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.0,
                children: [
                  StatCard(
                    icon: Icons.people,
                    label: 'Total Users',
                    value: '$totalUsers',
                  ),
                  StatCard(
                    icon: Icons.business,
                    label: 'Total Companies',
                    value: '$totalCompanies',
                  ),
                  StatCard(
                    icon: Icons.email,
                    label: 'Total Emails',
                    value: '$totalEmails',
                  ),
                  StatCard(
                    icon: Icons.phone,
                    label: 'Total Contact Numbers',
                    value: '$totalContacts',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const SectionTitle('CCS Programme Statistics'),
          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.0,
            children: [
              for (final p in programmes)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          p.code,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${p.students}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: lpuRed,
                          ),
                        ),
                        Text(
                          p.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
