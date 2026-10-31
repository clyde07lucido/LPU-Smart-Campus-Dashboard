import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String usersEndpoint = 'https://jsonplaceholder.typicode.com/users';

/// Week 2 - Part 2: retrieves live user data from the API.
Future<List<dynamic>> getUsers() async {
  final response = await http
      .get(Uri.parse(usersEndpoint))
      .timeout(const Duration(seconds: 15));

  // Part 4 (Activity 4.2) - debug statements, check the Debug Console.
  debugPrint('Status code: ${response.statusCode}');
  debugPrint('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }

  throw Exception('API Error (status ${response.statusCode})');
}
