// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:wemail/views/login_page.dart';
import 'package:wemail/views/reg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showloginpage = true;
  void showLogpage(){
    setState(() {
          showloginpage = true;
    });
  }
  void showRegpage(){
     setState(() {
       showloginpage = false;
     });
  }
  @override
  Widget build(BuildContext context) {
    if (showloginpage)
     {
      return loginpage(showRegpage: showRegpage);
    }else{
      return regpage(showLoginpage: showLogpage);
    }
  }
}