import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentcard/models/user.dart';
import 'package:studentcard/pages/admin/users_list.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/services/database.dart';
import 'package:studentcard/shared_components/constants.dart';
import 'package:studentcard/shared_components/loading.dart';
import 'package:studentcard/styles/app_colors.dart';
import 'package:studentcard/styles/app_text.dart';


class AdminDeleteAccount extends StatefulWidget {

  const AdminDeleteAccount({super.key});

  @override
  State<AdminDeleteAccount> createState() => _AdminDeleteAccountState();
}

class _AdminDeleteAccountState extends State<AdminDeleteAccount> {
  final List<String> user_type = ['Lecturer','Student', 'Administrator'];
  

  String selected_user = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MMUserData>>.value(
      value: DatabaseService().users,
      initialData: [],
      catchError: (context, error) {
        print(error.toString());
        return [];
      },


      child: loading ? Loading(): Scaffold(
          appBar: AppBar(
            title: Text("Delete account"),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            centerTitle: true,

          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  DropdownButtonFormField(
                      decoration: text("User Type"),
                      items: user_type.map(
                              (type) => DropdownMenuItem(
                              value: type,
                              child: Text("$type"))).toList(),
                      onChanged: (val) => setState(() {
                        selected_user = val!;
                        // print(selected_user);

                      })),
                  Text('$selected_user ', style: AppText.header2, textAlign: TextAlign.left,),
                  SizedBox(height: 20,),
                  Expanded(child: UserList(user_type: selected_user,)),
                ],
              )
          ),
        ),
    );


  }
}
