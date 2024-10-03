import 'package:flutter/material.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/shared_components/constants.dart';
import 'package:studentcard/shared_components/loading.dart';
import 'package:studentcard/styles/app_colors.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String userID = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Aligns children to the center horizontally
                    children: [
                      Flexible(
                        child: Image.asset(
                          'assets/images/mmu_logo.png',
                          fit: BoxFit.contain, // Adjusts the image size to fit within the available space
                        ),
                      ),
                      SizedBox(width: 10), // Adjust the width between the two images
                      Flexible(
                        child: Image.asset(
                          'assets/images/maskot.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
        
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: errorMessage(error),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      decoration: textFormField("MMU ID"),
                      validator: (val) => val!.isEmpty ? 'Enter User ID' : null,
                      onChanged: (val) {
                        setState(() {
                          userID = val + "@gmail.com";
                        });
                      },
                    ),
                  ),
        
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: textFormField("Password"),
                      validator: (val) => val!.isEmpty ? 'Enter password' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                  ),
        
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: ()async{
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth.signInWithUserIdAndPassword(userID, password);
        
        
                              if (result == null) {
                                setState(() {
                                  error = "Invalid User ID/Password. Try again";
                                  loading = false;
                                });
                              }
                            }
        
                            // Navigator.of(context).pushReplacementNamed('/admin');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.LoginBtn,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text("Log in")),
        
                    ),
                  ),
        
                  Spacer(),
        
        
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
