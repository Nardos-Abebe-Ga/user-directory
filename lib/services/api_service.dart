import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class ApiService {

  final String baseUrl =
      'https://dummyjson.com/users';

  // READ
  Future<List<UserModel>> fetchUsers() async {

    final response =
        await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body) ['users'];

      return data
          .map((json) =>
          UserModel.fromJson(json))
          .toList();

    } else {

      throw Exception('Failed to load users');
    }
  }

  // CREATE
  Future<UserModel> createUser(
      UserModel user) async {

    final response = await http.post(
      Uri.parse(baseUrl),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {

      return UserModel.fromJson(
        jsonDecode(response.body),
      );

    } else {

      throw Exception('Failed to create user');
    }
  }

  // UPDATE
  Future<UserModel> updateUser(
      int id,
      UserModel user,
      ) async {

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {

      return UserModel.fromJson(
        jsonDecode(response.body),
      );

    } else {

      throw Exception('Failed to update user');
    }
  }

  // DELETE
  Future<void> deleteUser(int id) async {

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {

      throw Exception('Failed to delete user');
    }
  }
}