import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emart/otherpages/appbutton.dart';
import 'package:emart/otherpages/g_a.dart';
import 'package:emart/otherpages/the_textfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RegisterApp());
}

class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  void signUpUser() async {
    setState(() {
      emailError = usernameController.text.isEmpty ? 'Please enter email' : null;
      passwordError = passwordController.text.isEmpty ? 'Please enter password' : null;
      confirmPasswordError = confirmPasswordController.text.isEmpty ? 'Please confirm password' : null;
    });

    if (emailError != null || passwordError != null || confirmPasswordError != null) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showCustomErrorDialog("Passwords don't match");
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
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

  void showCustomErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String errorCode) {
    String message;
    switch (errorCode) {
      case 'too-many-requests':
        message = 'Too many login attempts. Please try again later.';
        break;
      case 'email-already-in-use':
        message = 'The email address is already in use by another account.';
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        break;
      default:
        message = 'An error occurred. Please try again.';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Up Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
                const SizedBox(height: 35),
                const Text(
                  "Let's create an account",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 254, 115, 161),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sign Up Page',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 55, 212),
                  ),
                ),
                const SizedBox(height: 30),
                MyTextfeild(
                  controller: usernameController,
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
                  controller: passwordController,
                  hintText: ' Password',
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
                const SizedBox(height: 8),
                MyTextfeild(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obsecureText: true,
                ),
                if (confirmPasswordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        confirmPasswordError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Myappbutton(
                  text: 'Sign Up',
                  onTap: signUpUser,
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
                      'Already have an account?',
                      style: TextStyle(color: Color.fromARGB(137, 24, 20, 24)),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'LogIn now',
                        style: TextStyle(color: Colors.blue),
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
