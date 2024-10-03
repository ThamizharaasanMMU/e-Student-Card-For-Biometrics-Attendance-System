import 'package:flutter/material.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/shared_components/popupmenubutton.dart';
import 'package:studentcard/styles/app_text.dart';
import 'package:studentcard/styles/app_colors.dart';

class CampusStaffHomePage extends StatelessWidget {
  const CampusStaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              // Navigator.of(context).pushReplacementNamed('/');
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
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('Campus Staff Dashboard', style: AppText.header2,)),
              SizedBox(height: 40,),
              Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/mmu_logo.png')
              ),
              SizedBox(
                height: screenHeight*0.2,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 60,
                  width: screenWidth*0.8,

                  child: ElevatedButton(
                    onPressed: (){
                      // Navigator.of(context).pushNamed('/recognize');
                      Navigator.of(context).pushNamed('/recognize');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.BtnColor10,
                      foregroundColor: Colors.black,

                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/camera.png'),
                        Text("   Student Verification", style: TextStyle(fontSize: 20),),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

        ),

      ),
    );
  }
}
