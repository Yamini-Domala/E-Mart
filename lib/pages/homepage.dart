

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
 
  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 148, 86, 255),
        
        actions: [IconButton(onPressed: SignUserOut, icon: const Icon(Icons.logout))],
        
        ),
      body: const Center(child: Text("logged in"),),
    );
  }


  void SignUserOut() {
    FirebaseAuth.instance.signOut();
  }

  
}



