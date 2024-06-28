import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emart/otherpages/appbutton.dart';
import 'package:emart/otherpages/g_a.dart';
import 'package:emart/otherpages/the_textfield.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Loginapp());
}

class Loginapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loginpage(),
    );
  }
}

class Loginpage extends StatefulWidget {
  final Function()? onTap;
  const Loginpage({super.key, this.onTap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  String? emailError;
  String? passwordError;

  void loginuser() async {
    setState(() {
      emailError = usernamecontroller.text.isEmpty ? 'Please enter email' : null;
      passwordError = passwordcontroller.text.isEmpty ? 'Please enter password' : null;
    });

    if (emailError != null || passwordError != null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernamecontroller.text,
        password: passwordcontroller.text,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorDialog(e.code);
      }
    }
  }

  void showErrorDialog(String errorCode) {
    String message;
    switch (errorCode) {
      case 'invalid-credential':
        message = 'Incorrect E-mail address / password ';
        break;
      case 'too-many-requests':
        message = 'Too many login attempts. Please try again later.';
        break;
      default:
        message = 'An error occurred. Please try again.';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 232, 240),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock_person_rounded,
                  size: 85,
                ),
                const SizedBox(height: 35),
                const Text(
                  'Welcome to E-Mart',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 254, 115, 161),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login Page',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 55, 212),
                  ),
                ),
                const SizedBox(height: 30),
                MyTextfeild(
                  controller: usernamecontroller,
                  hintText: 'Username or Mail Id',
                  obsecureText: false,
                ),
                if (emailError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        emailError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                MyTextfeild(
                  controller: passwordcontroller,
                  hintText: 'Password',
                  obsecureText: true,
                ),
                if (passwordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        passwordError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 35, 34, 34),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Myappbutton(
                  text: 'LogIn',
                  onTap: loginuser,
                ),
                /*const SizedBox(height: 40),
                const Text(
                  '---Or Continue with---',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 254, 115, 161),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    squareTile(Imagepath: 'lib/images/google_logo.png'),
                    SizedBox(width: 20),
                    squareTile(Imagepath: 'lib/images/apple_logo.png'),
                  ],
                ),*/
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a Member?',
                      style: TextStyle(color: Color.fromARGB(137, 24, 20, 24)),
                    ),
                   GestureDetector(
                     onTap: widget.onTap,
                     child: const Text(
                            'Register Now',
                     style: TextStyle(color: Colors.blue),
                     ),
                     )

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
