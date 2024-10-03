import 'package:flutter/material.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/shared_components/popupmenubutton.dart';
import 'package:studentcard/styles/app_text.dart';
import 'package:studentcard/styles/app_colors.dart';


class AdminHomePage extends StatelessWidget {
  final String? pass;

  const AdminHomePage({super.key, required this.pass});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Set the icon color to white

            ),
            onPressed: () {

            },
          ),
            actions: [
              PopUpMenu(),
            ],

        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('Administrator Dashboard', style: AppText.header2,)),
              SizedBox(height: 40,),
              Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/mmu_logo.png')),
              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(

                        onPressed: (){
                          // print(pass);
                          Navigator.of(context).pushNamed('/create', arguments: pass);


                        },
                        child: Text("Create account"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.BtnColor8,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),

                        ),


                      ),

                    ),
                  ),
                  SizedBox(width: 25,),

                  SizedBox(
                    height: 100,
                    width: 150,
                    child: ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed('/delete');
                    },
                        child: Text("Delete account"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.BtnColor9,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),

                      ),
                    ),),
                  ),
                ],
              ),


              Spacer(),
            ],
          ),

        ),

      ),
    );
  }
}
