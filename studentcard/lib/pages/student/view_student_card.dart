import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentcard/styles/app_text.dart';


class ViewStudentCard extends StatelessWidget {
  const ViewStudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userUid = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("e-Student Card"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(userUid.toString()).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[500],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          child : Icon(Icons.person,size: 160,),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 3, color: Colors.grey[300],),

                SizedBox(height: 30,),
                Text("Name : ", style: AppText.label),
                Text(userData["firstname"] + " " + userData["lastname"], style: AppText.input,),
                SizedBox(height: 20,),
                Text("Student ID : ", style: AppText.label),
                Text(userData["userid"], style: AppText.input),
                SizedBox(height: 20,),
                Text("Faculty : ", style: AppText.label,),
                Text("Faculty of Computing and Informatics", style: AppText.input,),
                SizedBox(height: 20,),
                Text("Status : ", style: AppText.label),
                Text("Active in program", style: AppText.input,)

              ],
            ),
          );
        }
      ),
    );
  }
}
