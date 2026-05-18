import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {

  final ApiService apiService =
      ApiService();

  List<UserModel> users = [];

  bool isLoading = false;

  String errorMessage = '';

  // FETCH
  Future<void> getUsers() async {

    try {

      isLoading = true;

      notifyListeners();

      users =
      await apiService.fetchUsers();

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  // ADD
  Future<void> addUser(
      String name,
      String email,
      String phone,
      String company,
      ) async {

    try {

      isLoading = true;

      notifyListeners();

      final newUser =
      await apiService.createUser(
        UserModel(
          name: name,
          email: email,
          phone: phone,
          company: company,
        ),
      );

      users.insert(0, newUser);

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  // UPDATE
  Future<void> editUser(
      int id,
      String name,
      String email,
      String phone,
      String company,
      ) async {

    try {

      isLoading = true;

      notifyListeners();

      final updatedUser =
      await apiService.updateUser(
        id,
        UserModel(
          name: name,
          email: email,
          phone: phone,
          company: company,
        ),
      );

      int index = users.indexWhere(
            (user) => user.id == id,
      );

      if (index != -1) {

        users[index] = updatedUser;
      }

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }

  // DELETE
  Future<void> removeUser(int id) async {

    try {

      isLoading = true;

      notifyListeners();

      await apiService.deleteUser(id);

      users.removeWhere(
            (user) => user.id == id,
      );

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }
}