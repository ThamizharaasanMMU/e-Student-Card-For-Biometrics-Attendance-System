import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/pages/admin/user_tile.dart';


class UserList extends StatefulWidget {
  final String user_type;
  UserList({required this.user_type});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<MMUserData>>(context) ?? [];
    final filteredUsers = users.where((user) => user.userType == widget.user_type).toList();

    return ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          return UserTile(user: filteredUsers[index]);
        }
        );

  }
}
