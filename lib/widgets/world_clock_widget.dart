
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class WorldClockWidget extends StatefulWidget {
  const WorldClockWidget({super.key});

  @override
  State<WorldClockWidget> createState() =>
      _WorldClockWidgetState();
}

class _WorldClockWidgetState extends State<WorldClockWidget> {
  Timer? timer;

  final cities = [
    {'name': 'Manila', 'zone': 'Asia/Manila'},
    {'name': 'Tokyo', 'zone': 'Asia/Tokyo'},
    {'name': 'New York', 'zone': 'America/New_York'},
  ];

  @override
  void initState() {
    super.initState();
    tz_data.initializeTimeZones();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cities.map((city) {
        final location =
            tz.getLocation(city['zone']!);
        final now = tz.TZDateTime.now(location);

        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.access_time,
              color: Color(0xFFB5121B),
            ),
            title: Text(
              city['name']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('dd MMM yyyy').format(now),
            ),
            trailing: Text(
              DateFormat('hh:mm:ss a').format(now),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
