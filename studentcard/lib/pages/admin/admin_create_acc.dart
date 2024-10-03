import 'package:flutter/material.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/services/database.dart';
import 'package:studentcard/shared_components/constants.dart';
import 'package:studentcard/shared_components/loading.dart';
import 'package:studentcard/styles/app_colors.dart';


class AdminCreateAccount extends StatefulWidget {
  const AdminCreateAccount({super.key});

  @override
  State<AdminCreateAccount> createState() => _AdminCreateAccountState();
}

class _AdminCreateAccountState extends State<AdminCreateAccount> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final List<String> user_type = ['Lecturer','Student', 'Administrator', 'Campus Staff'];
  bool loading = false;

  String firstName = '';
  String lastName = '';
  String userType = '';
  String userID = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    final String? pass = ModalRoute.of(context)?.settings.arguments as String?;
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
        title: Text("Create account"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                decoration: text("First name"),
                validator: (val) => val!.isEmpty ? "Please enter full name" : null,
                onChanged: (val) {
                  firstName = val.toUpperCase();
                },


              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: text("Last name"),
                validator: (val) => val!.isEmpty ? "Please enter last name" : null,
                onChanged: (val) {
                  lastName = val.toUpperCase();
                },


              ),
              SizedBox(height: 20,),
              DropdownButtonFormField(
                decoration: text("User Type"),
                  items: user_type.map(
                          (type) => DropdownMenuItem(
                              value: type,
                              child: Text("$type"))).toList(),
                  onChanged: (val) => setState(() {
                    userType = val!;

                  })),
              SizedBox(height: 20,),
              TextFormField(
                decoration: text("MMU User ID"),
                validator: (val) => val!.isEmpty ? "Please enter MMU User ID" : null,
                onChanged: (val) {
                  setState(() {
                    userID = val + "@gmail.com";
                  });
                },


              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: text("Password"),
                obscureText: true,
                validator: (val) => val!.length < 6 ? "Password is too short" : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },


              ),
              Spacer(),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.LoginBtn,
                  ),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        // print(pass);

                        dynamic output = await _auth.registerUserWithCredentials(firstName, lastName, userType, userID, password, pass!);
                        if (output == null) {
                          setState(() {
                            loading = false;
                          });
                        }
                        final snackBar = SnackBar(
                          content: Text('$userType account created successfully !'),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Create",
                      style: TextStyle(color: Colors.black),)
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),

    );
  }
}
