import 'package:flutter/material.dart';

InputDecoration text (String hint) {
  return InputDecoration(
    hintText: hint,
    fillColor: Color(0XFFF2F2F2),
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
    ),


  );
}

InputDecoration textFormField (String hintText) {
  return InputDecoration(
    hintText: hintText,
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
  );
}


Text errorMessage (String message) {
  return Text(message,
    style: TextStyle(
      color: Colors.red,
      fontSize: 16.0,
  ),);
}