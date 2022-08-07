import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:login_ui/DB/db_helper.dart';
import 'package:login_ui/DB/user_model.dart';
import 'package:login_ui/component/check_internet.dart';
import 'package:login_ui/component/gradient_text.dart';
import 'package:login_ui/component/tost.dart';
import 'package:login_ui/screens/login_screen.dart';
class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController userEmail = TextEditingController();

  TextEditingController userPhone = TextEditingController();

  TextEditingController userPassword = TextEditingController();
  TextEditingController conformPassword = TextEditingController();
  var dbHelper=DbHelper();

  bool passText = true;
  bool cpassText = true;

  final _formKey = GlobalKey<FormState>();


  signUP()async {
    String uemail=userEmail.text;
    String uphone=userPhone.text;
    String pass=userPassword.text;
    String cPass=conformPassword.text;
    if (_formKey.currentState!.validate()) {

      if(pass!=cPass){
        showtoast(Colors.red,"Password doesn't match");

      }
      else{
        _formKey.currentState!.save();
       UserModel uModel=UserModel(uemail, uphone, pass);
        await dbHelper.saveData(uModel).then((userData) {
          showtoast(Colors.green,"SignUp Successfully");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LogInScreen()));
        }).catchError((error){
          print(error);
        });

      }

    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  dbHelper=DbHelper();
    checkInternet();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet=status==InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet=hasInternet;
      });
    });
  }
  bool hasInternet=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key:_formKey ,
          child: Column(
            children: [
              GradientText(
                'Sign Up',
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

              Padding(
              padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: userEmail,
            validator: (value)=>
              value!.isEmpty ? 'Email cannot be blank' : EmailValidator.validate(value)==false?'Please enter valid email':null,



            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.email,
                color: Colors.grey,
              ),
              labelText: "Email Address",
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
      ) ,
      Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: userPhone,
                // The validator receives the text that the user has entered.
                validator: (value) =>
                value!.isEmpty ? 'Please Enter phone number' : null,

                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  labelText: "Phone Number",
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
                  obscureText: passText,

                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        passText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          passText = !passText;
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) =>
                  value!.isEmpty ? 'Password cannot be empty' : null,
                  controller: conformPassword,
                  obscureText: cpassText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        cpassText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          cpassText = !cpassText;
                        });
                      },
                    ),
                    labelText: "Conform Password",
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
                      onPressed:signUP,
                      child: const Text("SignUP")),
                  TextButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LogInScreen()));
                  }, child: Text("Login",style: TextStyle(fontSize: 20),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
