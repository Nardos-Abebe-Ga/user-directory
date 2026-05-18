import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/user_tile.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final companyController = TextEditingController();
  final searchController = TextEditingController();

  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    searchController.addListener(_updateSearchQuery);
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).getUsers();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      searchQuery = searchController.text.trim();
    });
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    companyController.clear();
  }

  void showUserDialog({int? id}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(id == null ? 'Add User' : 'Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                clearFields();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<UserProvider>(context, listen: false);
                if (id == null) {
                  await provider.addUser(
                    nameController.text,
                    emailController.text,
                    phoneController.text,
                    companyController.text,
                  );
                } else {
                  await provider.editUser(
                    id,
                    nameController.text,
                    emailController.text,
                    phoneController.text,
                    companyController.text,
                  );
                }
                clearFields();
                Navigator.pop(context);
              },
              child: Text(id == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  List<UserModel> filteredUsers(List<UserModel> users) {
    if (searchQuery.isEmpty) {
      return users;
    }

    final query = searchQuery.toLowerCase();
    return users.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.phone.toLowerCase().contains(query) ||
          user.company.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final users = filteredUsers(provider.users);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('User Directory'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          clearFields();
          showUserDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      provider.errorMessage,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: provider.getUsers,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Welcome back',
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Manage your users quickly and easily.',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                          child: Icon(
                                            Icons.people,
                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(Icons.search),
                                    hintText: 'Search by name, email, phone, or company',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text(
                                    '${users.length} users found',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        users.isEmpty
                            ? SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    'No users match your search.',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final user = users[index];
                                    return UserTile(
                                      user: user,
                                      onEdit: () {
                                        nameController.text = user.name;
                                        emailController.text = user.email;
                                        phoneController.text = user.phone;
                                        companyController.text = user.company;
                                        showUserDialog(id: user.id);
                                      },
                                      onDelete: () {
                                        provider.removeUser(user.id!);
                                      },
                                    );
                                  },
                                  childCount: users.length,
                                ),
                              ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 90),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}