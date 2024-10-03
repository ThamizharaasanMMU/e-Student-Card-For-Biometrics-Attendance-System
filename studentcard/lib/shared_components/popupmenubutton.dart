import 'package:flutter/material.dart';
import 'package:studentcard/services/authentication.dart';

enum ProfileMenu {
  logout
}

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<ProfileMenu>(
      onSelected: (value) {
        switch(value) {
          case ProfileMenu.logout:
            AuthService().signOut();
            break;
        }
      },
      icon: const Icon(Icons.person, color: Colors.white),
      itemBuilder: (context){
        return [
          PopupMenuItem(child: Text("Log out"), value: ProfileMenu.logout,),

        ];

      },);
  }
}
