// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:wemail/constants.dart';
import 'package:wemail/workers/Stat.dart';
import 'package:wemail/workers/api.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// ignore: camel_case_types
class loginpage extends StatefulWidget{
  final VoidCallback showRegpage;
  const loginpage({Key? key, required this.showRegpage}) :super(key: key);
  @override
  State<loginpage> createState()=> _loginpageState();
}

// ignore: camel_case_types
class _loginpageState extends State<loginpage>{
  var usertxtmain = TextEditingController();
  var passtxt = TextEditingController();
  String btndistxt = "Login";
  bool isbtnactive = true;
  bool isbtnactive2 = true;
  bool hasdone = false;
  String txt = "";
  Future<void> loginuser() async {
     var pro =  ProgressDialog(context, title: Text("Please Wait"), message: Text("Verifying Credentials"), dismissable: false );
    try {
     
        btndistxt = "Authenticating...";
      isbtnactive = false;
      isbtnactive2 = false;
      // SystemChannels.textInput.invokeMethod("TextInput.hide");
     setState(() {
      
     });
      if(usertxtmain.text.removeAllWhitespace().isEmpty || passtxt.text.removeAllWhitespace().isEmpty){
        txt = "Password cannot be empty";
        pro.dismiss();
        errorp.showErr(txt, context);
        btndistxt = "login";
        isbtnactive = true;
        isbtnactive2 = true;
        ss();
        return;
      }
      pro.show();
      FocusScope.of(context).unfocus();
      errorp.working(btndistxt, context);
      var usr = usertxtmain.text.removeAllWhitespace();
      var pswd = passtxt.text.removeAllWhitespace();
      Udata u = Udata( usr,pswd );
      
         
         var email = "${u.user}@wemail.com";
         var password = "${u.pass}8230";
         await FirebaseAuth.instance
         .signInWithEmailAndPassword(email: email, password: password )
         .then((value) {Stat.olduser = true; });
      
    } on FirebaseAuthException catch (e) {
      pro.dismiss();
      errorp.showErr(e.message!.swi(), context);
      btndistxt = "login";
        isbtnactive = true;
        isbtnactive2 = true;
        ss();
    }
      
       //gg
    }
    @override
  void dispose() {
    usertxtmain.dispose();
    passtxt.dispose();
    super.dispose();
  }
  @override
  void initState() {
    isbtnactive = false;
    var usertxt = TextEditingController();
    usertxt.addListener(() {
      setState(() {
        isbtnactive = usertxtmain.text.trim().isNotEmpty; 
      });
      
    });
    usertxtmain = usertxt;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      FlutterNativeSplash.remove();
     });
    super.initState();
  }
  void ss(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context){
    
    return Scaffold
    (extendBody: true,
    extendBodyBehindAppBar: true,
      backgroundColor: authPageBGcolor,
      appBar: AppBar(backgroundColor: appBarColor, elevation: 0, toolbarHeight: 1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
           [
            SizedBox(height: 20,),
            Icon(Icons.key, size: 100,
            ),
            SizedBox(height: 20,),
            //text login
            Text("Login".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, 
            fontSize: 30, color: Colors.black,), ),
            SizedBox(height: 30,),
            // username txtbox
            Padding(
              
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: usertxtmain,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username"
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            // pass txtbox
             Padding(
              
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passtxt,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password"
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
                //login button
              ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(200, 50)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(isbtnactive? Colors.red : Color.fromARGB(255, 107, 102, 102)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isbtnactive? Colors.red : Color.fromARGB(255, 107, 102, 102))
          )
                )
                
              ),
              onPressed: isbtnactive? () async{
                loginuser();
              } : null
              ,
              child: Text( isbtnactive?
                "login".toUpperCase(): btndistxt.toUpperCase(),
                style: TextStyle(fontSize: 14)
              )
            ),
            SizedBox(height: 30,),
            //not reg link
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                Text("not a user? ",
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 99, 100, 100)),
                ),
                 GestureDetector(
                  onTap: isbtnactive2? () =>  widget.showRegpage(): null,
                  child: Text
                 (
                  "Register", 
                  style: TextStyle(fontWeight: FontWeight.bold, 
                  fontSize: 20, color: Color.fromARGB(255, 29, 30, 102) ), )
                  ),
               ],
             ),
          ]),
        ),
      ),
    );
  }
}

class Udata {
  String user;
  String pass;
  int? id;
  int? cash;
  String? name;
 Udata(this.user, this.pass);
 Map<String, dynamic> tojson() => 
 {
    'user': user,
    'pass': pass,
    'id': id,
    'name':name
 };
  fill (Map<String, dynamic> json ){
  id = json["dat"][0]["id"];
  cash = json["dat"][0]["cash"];
  name = json["dat"][0]["name"];
 }
 Map<String, dynamic> tofire() => 
 {
    'user': user,
    'email': "$user@wemail.com",
    'name':name,
    'cash':cash
 };
 fillid (Map<String, dynamic> json ){
  id = json["dat"][0]["id"];
 }
}

extension ExtendedString on String {
  String removeAllWhitespace() {
    return replaceAll(RegExp(r"\s+"), "");
  }
  String swi(){
    return replaceAll(RegExp(r"email address"), "username");
  }

  String pswd(){
    return replaceAll(RegExp(r"String"), "Password");
  }
}
