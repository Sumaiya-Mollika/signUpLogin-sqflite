import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showtoast(Color color, String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor:color,
      textColor: Colors.white);
}