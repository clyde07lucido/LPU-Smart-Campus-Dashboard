import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';
import '../widgets/api_builder.dart';
import '../widgets/info_row.dart';

/// Week 2 - Part 3 (Exercises 3 & 4): live user cards from the API.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<dynamic>> usersFuture;

  @override
  void initState() {
    super.initState();
    usersFuture = getUsers();
  }

  void reload() {
    setState(() {
      usersFuture = getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lpuRed,
        foregroundColor: lpuWhite,
        title: const Text(
          'User Directory (Live API)',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Reload API data',
            icon: const Icon(Icons.refresh),
            onPressed: reload,
          ),
        ],
      ),
      body: ApiBuilder(
        future: usersFuture,
        onRetry: reload,
        builder: (users) {
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final String name = user['name'];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: lpuRed,
                    foregroundColor: lpuWhite,
                    child: Text(name[0]),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
                          icon: Icons.email_outlined,
                          text: user['email'],
                        ),
                        InfoRow(
                          icon: Icons.phone_outlined,
                          text: user['phone'],
                        ),
                        InfoRow(
                          icon: Icons.business,
                          text: user['company']['name'],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
