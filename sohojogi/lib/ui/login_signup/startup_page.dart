import 'package:flutter/material.dart';
import 'package:sohojogi/constants.dart';
import 'package:sohojogi/ui/login_signup/signup_page.dart';
import 'package:sohojogi/ui/login_signup/login_page.dart';


class startup_page extends StatefulWidget {
  const startup_page({super.key});

  @override
  State<startup_page> createState() => _startup_pageState();
}

class _startup_pageState extends State<startup_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Welcome",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg')
                    )
                ),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => login_page()));
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Login", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  ),
                  SizedBox(height: 20,),
                  Container(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => signup_page()));
                      },
                      color: Constants.secondaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Sign up", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
