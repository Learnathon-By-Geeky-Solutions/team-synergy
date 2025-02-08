import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';
import 'package:sohojogi/ui/login_signup/auth_check.dart';
import 'package:sohojogi/ui/login_signup/signup_page.dart';
import 'package:sohojogi/ui/root_page.dart';


class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final emailController=TextEditingController();
  final passController=TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void passReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim(),);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text("Password Reset Email Sent", style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
            ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }on FirebaseAuthException catch(e){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(e.message.toString(), style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
            ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }
  }
  void loggedin() async{
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => auth_check()));
    }on FirebaseAuthException catch (e){
      print(e);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text(e.message.toString(), style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
            ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Login", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 20,),
                      Text("Login to your account", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                      ),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        makeInput(label: "Email",fieldcontroller: emailController),
                        makeInput(label: "Password",fieldcontroller: passController, obscureText: true),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      //padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          loggedin();
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootPage()));
                        },
                        color: Constants.secondaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Login", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => signup_page()));
                        },
                        child: Text("Create an Account?", style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18
                        ),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          passReset();
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signup_page()));
                        },
                        child: Text("Forgot Your Password?", style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15
                        ),),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeInput({label,fieldcontroller, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 5,),
        TextField(
          obscureText: obscureText,
          controller: fieldcontroller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}
