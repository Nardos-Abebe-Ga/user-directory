import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserTile({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  Color _avatarColor(BuildContext context) {
    final colors = [
      Colors.indigo,
      Colors.deepPurple,
      Colors.teal,
      Colors.orange,
      Colors.cyan,
    ];
    return colors[user.id != null ? user.id! % colors.length : 0].withOpacity(0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          tileColor: Colors.white,
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: _avatarColor(context),
            child: Text(
              user.name.isNotEmpty ? user.name[0] : '?',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      user.email,
                      style: const TextStyle(color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    user.phone,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      user.company,
                      style: const TextStyle(color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.indigo),
                onPressed: onEdit,
                tooltip: 'Edit user',
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
                tooltip: 'Delete user',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
