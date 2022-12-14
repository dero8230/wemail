// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wemail/views/Home.dart';
import 'package:wemail/workers/auth_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)
         {
          if(snapshot.hasData)
          {
            return Home(user: snapshot.data!,); 
          }else{
            return AuthPage();
          }
        },
        ),
    );
  }
}