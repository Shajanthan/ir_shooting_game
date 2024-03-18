import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ir_shooting_game/components/MyButton.dart';
import 'package:ir_shooting_game/components/my_textfield.dart';
import 'package:ir_shooting_game/signup.dart';
import 'package:ir_shooting_game/wrapper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();



  Future<void> signin() async {
    showDialog(
        context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    );
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
        );
        // User sign-in successful
        print("User signed in: ${userCredential.user?.email}");

        // You can navigate to another screen or perform additional actions here
      } catch (e) {
        Navigator.pop(context);
        // Handle sign-in errors
        print("Error during sign-in: $e");
        _showErrorMessage(
            "Please check Email and Password");
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /*
  void signin()async{



    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
      );
      Navigator.pop(context);
      
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      if (e.code=='user-not-found') {
        wrongEmail();
      } else{
        wrong();
      }
    }
  }
  
     void wrongEmail() {
      showDialog(
        context: context,
        builder: (context){
        return const AlertDialog(
          title: Text('Incorrext Email and Password'),
        );
      },
    );
    }

    void wrong() {
      showDialog(
        context: context,
        builder: (context){
        return const AlertDialog(
          title: Text('Incorrext Email and Password'),
        );
      },
    );
    }
*/

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
                const SizedBox(height: 50),

                Text(
                  "Login",
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
                  controller: password,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                MyButton(
                  onTap: signin,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   InkWell(
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text(
                    'Create new account? Signup',
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