import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ir_shooting_game/components/my_textfield.dart';
import 'package:ir_shooting_game/login.dart';

import 'components/MyButton2.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();
  final TextEditingController Cpassword=TextEditingController();
  final TextEditingController name=TextEditingController();

  final databaseref=FirebaseDatabase.instance.ref("player");

  void signup()async{
    if (password.text==Cpassword.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        String k = email.text.substring(0,email.text.length - 10);

        // User registration successful
        print("User registered: ${userCredential.user?.email}");
        databaseref.child(k).set({
          "score":int.parse(DateTime.now().microsecond.toString()),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );

        // You can navigate to another screen or perform additional actions here
      } catch (e) {
        // Handle registration errors
        print("Error during registration: $e");
        accountErr();
      }
    }
    else {
      passwordError();
    }

  }
  void accountErr() {
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          title: Text('Error'),
        );
      },
    );
  }

  void passwordError() {
      showDialog(
        context: context,
        builder: (context){
        return const AlertDialog(
          title: Text('Password not matched'),
        );
      },
    );
    }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Center(
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Signup",
                  style: TextStyle(color: Colors.black,fontSize: 50,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),

                MyTextField(
                  controller: email,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: name,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: password,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: Cpassword,
                  hintText: 'Confirm-Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                MyButton2(
                  onTap: signup,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        'Click here to login',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ),

      );
    }
}