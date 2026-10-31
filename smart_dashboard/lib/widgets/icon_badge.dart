import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// Red icon inside a soft round background. Reused by cards, tiles and lists.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final double radius;

  const IconBadge(this.icon, {super.key, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: lpuRedLight,
      child: Icon(icon, color: lpuRed, size: radius),
    );
  }
}
