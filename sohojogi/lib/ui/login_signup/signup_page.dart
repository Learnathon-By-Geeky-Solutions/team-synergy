import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';
import 'package:sohojogi/ui/login_signup/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sohojogi/ui/login_signup/startup_page.dart';

class signup_page extends StatefulWidget {
  const signup_page({super.key});

  @override
  State<signup_page> createState() => _signup_pageState();
}

class _signup_pageState extends State<signup_page> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  late User currentUser;

  Future addUserDetails(String email,String name, String UID) async{
    await FirebaseFirestore.instance.collection('users').add(
        {
          'email':email,
          'name':name,
          'uid':UID,
        }
    );
  }

  Future<void> signUp() async {
    if(passwordController.text==confirmPasswordController.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        currentUser = FirebaseAuth.instance.currentUser!;
        print(currentUser.uid);
        addUserDetails(emailController.text, nameController.text,currentUser.uid);
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              alignment: Alignment.center,
              title: Text("Account Created", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              ),
                textAlign: TextAlign.center,
              ),
            );
          },
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> startup_page()),);
      } on FirebaseAuthException catch (e) {
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
    else{
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            alignment: Alignment.center,
            title: Text("Confirmation Password didn't matched", style: TextStyle(
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 40),
              Column(
                children: <Widget>[
                  Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                      "Create an account, It's free",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
              Column(
                children: <Widget>[
                  makeInput(label: "Email", fieldcontroller: emailController),
                  makeInput(label: "Password", fieldcontroller: passwordController, obscureText: true),
                  makeInput(label: "Confirm Password", fieldcontroller: confirmPasswordController, obscureText: true),
                  makeInput(label: "Name", fieldcontroller: nameController, obscureText: true),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: (){
                      signUp();
                    },
                    color: Constants.secondaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> login_page()),);
                      },
                      child: Text(" Log In", style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                    ),
                  ],
                ),
            ],
          ),
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
