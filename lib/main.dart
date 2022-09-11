// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemail/views/mainpage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


 void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) 
  {
    await Firebase.initializeApp
  (
    options: FirebaseOptions( apiKey: "AIzaSyCNE0SjTDKDOepneQwyPFgFknJMdjrtNMY",
  authDomain: "wemail-be433.firebaseapp.com",
  projectId: "wemail-be433",
  storageBucket: "wemail-be433.appspot.com",
  messagingSenderId: "204754131246",
  appId: "1:204754131246:web:2c343a6425a088cc9f02bf")
  );
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.light,
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.transparent, ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wemail',
      debugShowCheckedModeBanner: false,
      home: const MainPage() ,
      //  routes: {
      //   MainPage.rout:(context) => loginpage(),
      //   loginpage.rout:(context) => loginpage(),
      //   Home.rout:(context) => Home(),
      //   regpage.rout:(context) => regpage(),
      // },
    );
  }
}

