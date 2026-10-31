import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// Shows a loading spinner, an error message with a retry button,
/// or the content built from the API data.
class ApiBuilder extends StatelessWidget {
  final Future<List<dynamic>> future;
  final VoidCallback onRetry;
  final Widget Function(List<dynamic> users) builder;

  const ApiBuilder({
    super.key,
    required this.future,
    required this.onRetry,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: lpuRed),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: lpuRed),
                  const SizedBox(height: 12),
                  const Text('API Error', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    '${snapshot.error ?? 'No data received'}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: lpuRed),
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        return builder(snapshot.data!);
      },
    );
  }
}
