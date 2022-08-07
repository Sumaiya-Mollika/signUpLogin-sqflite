import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:login_ui/DB/db_helper.dart';
import 'package:login_ui/DB/user_model.dart';

import 'package:login_ui/component/gradient_text.dart';
import 'package:login_ui/screens/home_screen.dart';
import 'package:login_ui/screens/sign_up.dart';
import 'package:login_ui/component/tost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  TextEditingController userEmail = TextEditingController();

  TextEditingController userPassword = TextEditingController();
  var dbHelper = DbHelper();
  bool isInternet = false;
  bool isObscureText = true;
  final _formKey = GlobalKey<FormState>();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    // TODO: implement initState
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    super.initState();
    dbHelper = DbHelper();
    // checkInternet();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  login() async {
    String uemail = userEmail.text;
    String pass = userPassword.text;

    if (_formKey.currentState!.validate()) {
      await dbHelper.getLogin(uemail, pass).then((userData) {
        print("${userData!.email}");
        if (userData != null) {
          setSP(userData).whenComplete(() {
            showtoast(Colors.green, "Login Successfully");
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
        }
      }).catchError((error) {
        print(error);
        showtoast(Colors.red, "Login Failed");
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;
    sp.setString('email', user.email!);
    sp.setString('phone', user.phone!);
    sp.setString('password', user.password!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text("LogIn"),
        // ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GradientText(
                'Login',
                style: TextStyle(fontSize: 40),
                gradient: LinearGradient(colors: [
                  Colors.purple.shade200,
                  Colors.pink,
                  Colors.purple,
                  Colors.deepPurple,
                  Colors.deepPurple,
                  Colors.indigo,
                  Colors.blue,
                  Colors.lightBlue,
                  Colors.cyan,
                  Colors.teal,
                  Colors.green,
                  Colors.lightGreen,
                  Colors.lime,
                  Colors.yellow,
                  Colors.amber,
                  Colors.orange,
                  Colors.deepOrange,
                ]),
              ),
              isInternet==false?  Text("you are offline",style: TextStyle(
                 color:Colors.red
              ),):Text(""),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: userEmail,
                  validator: (value) =>
                      value!.isEmpty ? 'User Name cannot be blank' : null,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    labelText: "User Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Password cannot be empty' : null,
                  controller: userPassword,
                  obscureText: isObscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscureText = !isObscureText;
                        });
                      },
                    ),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40)),
                  onPressed: login,
                  child: const Text("Login")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        "SignUP",
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    setState(() {
      isInternet = status;
    });

    // final snackBar = SnackBar(
    //     content: Text("${status ? 'ONLINE\n' : 'OFFLINE\n'}"),
    //     backgroundColor: status ? Colors.green : Colors.red);
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
