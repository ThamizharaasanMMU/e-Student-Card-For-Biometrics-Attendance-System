import 'package:flutter/material.dart';
import 'package:studentcard/services/authentication.dart';
import 'package:studentcard/shared_components/popupmenubutton.dart';
import 'package:studentcard/styles/app_text.dart';
import 'package:studentcard/styles/app_colors.dart';

class LecturerHomePage extends StatefulWidget {
  const LecturerHomePage({super.key});

  @override
  State<LecturerHomePage> createState() => _LecturerHomePageState();
}

class _LecturerHomePageState extends State<LecturerHomePage> {

  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Set the icon color to white

            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();

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
                  child: Text('Lecturer Dashboard', style: AppText.header2,)),
              SizedBox(height: 40,),
              Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/mmu_logo.png')),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/mark_attendance');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.BtnColor5,
                      foregroundColor: Colors.white,

                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/checkbox.png'),
                        Text("   Mark attendance"),

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/exam');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.BtnColor6,
                      foregroundColor: Colors.white,

                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/edit.png'),
                        Text("   Examination"),

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('/exam_verification');

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.BtnColor7,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/icons/face-solid.png'),
                        Text("  Student verification in exam"),

                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),

        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text('Lecturer Dashboard'),
              ),
              ListTile(
                title: const Text('Home'),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Student Verification'),
                selected: _selectedIndex == 1,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(1);
                  // Then close the drawer
                  Navigator.of(context).pushNamed('/recognize');
                  _onItemTapped(0);
                },
              ),
            ],
          ),
        ),

      ),
    );
  }
}
