import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
bool hasInternet=false;
ConnectivityResult result=ConnectivityResult.none;

checkInternet()async{
  hasInternet=  await InternetConnectionChecker().hasConnection;
  result=await Connectivity().checkConnectivity();
  final color=hasInternet?Colors.green:Colors.red;
  final text=hasInternet?"Connected":"Offline";
  if(result==ConnectivityResult.mobile){
    showSimpleNotification(Text("Mobile Network $text",style: TextStyle(color: Colors.white),),
      background: color,
    );
  }

  else if(result==ConnectivityResult.wifi){
    showSimpleNotification(Text("Wifi $text",style: TextStyle(color: Colors.white),),
      background: color,
    );
  }
  else{
    showSimpleNotification(Text("$text",style: TextStyle(color: Colors.white),),
      background: color,
    );
  }

}

