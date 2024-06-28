import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'Register.dart';
class login_or_signup extends StatefulWidget {
  const login_or_signup({super.key});

  @override
  State<login_or_signup> createState() => _login_or_signupState();
}

class _login_or_signupState extends State<login_or_signup> {
  //show login page first
  bool showLoginPage = true;

  void togglebwpages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });

  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return Loginpage(
        onTap: togglebwpages,
      );
    }
    else{
      return  RegisterPage(
        onTap: togglebwpages,
      );
  }
}}