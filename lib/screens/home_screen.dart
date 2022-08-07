import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/DB/db_helper.dart';
import 'package:login_ui/DB/user_model.dart';
import 'package:login_ui/component/check_internet.dart';
import 'package:login_ui/component/gradient_text.dart';
import 'package:login_ui/component/tost.dart';
import 'package:login_ui/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEmail = TextEditingController();
  TextEditingController delUser= TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  bool isObscureText = true;
  DbHelper? dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    dbHelper = DbHelper();
    checkInternet();

  }

  Future<void> getUser() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      userEmail.text = sp.getString('email')!;
      delUser.text = sp.getString('email')!;
      userPhone.text = sp.getString('phone')!;
      userPassword.text = sp.getString('password')!;
    });
  }

  update() async {
    String uemail = userEmail.text;
    String uphone = userPhone.text;
    String pass = userPassword.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserModel user = UserModel(uemail, uphone, pass);
      await dbHelper!.updatUser(user).then((value) {
        if (value == 1) {
          showtoast(Colors.green, "Successfully Update");
          updateSP(user,true).whenComplete(() {
            // Navigator.pop(context);
          });
        } else {
          showtoast(Colors.red, "Update Failed");
        }
      }).catchError((error) {
        showtoast(Colors.red, "Error");
      });
    }
  }
delete()async{
    String deletUser=delUser.text;
    await dbHelper!.delUser(deletUser).then((value){
      if (value == 1) {
        showtoast(Colors.green, "Delete Successfully");

        updateSP(null, false).whenComplete(() {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LogInScreen()));
        });
      }
    });
}
  Future updateSP(UserModel ?user,bool add) async {
    final SharedPreferences sp = await _pref;
    if(add){
      sp.setString('email', user!.email!);
      sp.setString('phone', user.phone!);
      sp.setString('password', user.password!);
    }
else{
  sp.remove('email');
  sp.remove('phone');
  sp.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("HomeScreen"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("${userEmail.text}",)),
          ),
        ],
      ),
      drawer: Drawer(

      ),
     body: Form(
       key: _formKey,
       child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
         children: [
           GradientText(
             'User Info',
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
               validator: (value) => value!.isEmpty
                   ? 'Email cannot be blank'
                   : EmailValidator.validate(value) == false
                   ? 'Please enter valid email'
                   : null,
               enabled: false,
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
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextFormField(
               controller: userPhone,
               // The validator receives the text that the user has entered.
               validator: (value) =>
               value!.isEmpty ? 'Please Enter phone number' : null,
               enabled: true,
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
               obscureText: isObscureText,
               enabled: false,
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
               style:
               ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
               onPressed: update,
               child: const Text("Update")),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextFormField(
               keyboardType: TextInputType.emailAddress,
               controller: delUser,
               validator: (value) => value!.isEmpty
                   ? 'Email cannot be blank'
                   : EmailValidator.validate(value) == false
                   ? 'Please enter valid email'
                   : null,
               enabled: false,
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
           ),
           ElevatedButton(
               style:
               ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
               onPressed: delete,
               child: const Text("Delete")),
           ElevatedButton(
               style:
               ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
               onPressed:checkInternet,
               child: const Text("Check Internet")),
         ],
       ),
     ),
    );
  }
}
