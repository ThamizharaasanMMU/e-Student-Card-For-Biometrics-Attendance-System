import 'package:flutter/material.dart';
import 'package:studentcard/styles/app_text.dart';


class DisplayNothing extends StatelessWidget {
  final String message;
  const DisplayNothing({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(message, style: AppText.header2,),

      ),
    );
  }
}
