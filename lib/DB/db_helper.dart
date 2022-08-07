import 'package:flutter/material.dart';
import 'package:login_ui/DB/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
class DbHelper{
  static Database ? _db;
  static const int Version=1;
  static const String DB_Name='login.db';
  static const String Table_User='user';
  static const String C_Email='email';
  static const String C_Phone='phone';
  static const String C_Password='password';


  Future<Database> get db async{
    if(_db !=null){
      return _db!;
    }
    _db=await initDb();
    return _db!;
  }

  initDb()async{
  io.Directory documentsDirectory=await getApplicationDocumentsDirectory();
  String path=join(documentsDirectory.path,DB_Name);
  var db=await openDatabase(path,version: Version,onCreate: _onCreate);
  return db;
  }

  _onCreate(Database db,int intVersion)async{
await db.execute("CREATE TABLE $Table_User("
    " $C_Email TEXT, "
    " $C_Phone TEXT, "
    " $C_Password TEXT, "
    " PRIMARY KEY ($C_Email)"
    ")"
);
  }

  Future<int> saveData (UserModel user)async{
var dbClient=await db;
var res=await dbClient.insert(Table_User, user.toMap());
return res;
  }

  Future<UserModel?>getLogin(String email,String passwrd)async{
    var dbClient=await db;
    var res=await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_Email = '$email' AND "
        "$C_Password = '$passwrd'");
    if(res.length>0){
      return UserModel.fromMap(res.first);
    }
    return null;
  }
  Future<int> updatUser(UserModel user)async{
    var dbClient=await db;
    var res=await dbClient.update(Table_User, user.toMap(),where: '$C_Email = ?',whereArgs: [user.email]);
    return res;
  }

  Future<int> delUser(String email)async{
    var dbClient=await db;
    var res=await dbClient.delete(Table_User,where: '$C_Email = ?',whereArgs: [email] );
    return res;
  }
}
