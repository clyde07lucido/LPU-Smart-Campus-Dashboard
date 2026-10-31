import 'package:flutter/material.dart';

/// Scrollable page body that stays readable on tablets (max width 600).
class CenteredList extends StatelessWidget {
  final List<Widget> children;

  const CenteredList({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: children,
        ),
      ),
    );
  }
}
