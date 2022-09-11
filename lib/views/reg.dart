// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:wemail/constants.dart';
import 'package:wemail/workers/Stat.dart';
import 'package:wemail/workers/api.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wemail/views/login_page.dart';

// ignore: camel_case_types
class regpage extends StatefulWidget{
  final VoidCallback showLoginpage;
  const regpage({Key? key, required this.showLoginpage}) :super(key: key);
  static const rout = "reg";
  @override
  State<regpage> createState()=> _regpageState();
}

// ignore: camel_case_types
class _regpageState extends State<regpage>{
  late TextEditingController usertxtmain  ;
  late TextEditingController passtxt;
  late TextEditingController nametxt ;
  String btndistxt = "Register";
  bool isbtnactive = true;
  bool isbtnactive2 = true;
  String txt = "";
  Future<void> reguser() async {
     var pro = ProgressDialog(context, title: Text("Please Wait"), message: Text("Registering User"), dismissable: false );
    try {
      FocusScope.of(context).unfocus();
      pro.show();
     setState(() {
      txt = "";
      btndistxt = "Registering...";
      isbtnactive = false;
      isbtnactive2 = false;
     });
      var usr = usertxtmain.text.removeAllWhitespace();
      var pswd = passtxt.text;
      Udata u = Udata( usr,pswd);
      u.name = nametxt.text.trim();
         var email = "${u.user}@wemail.com";
         var password = "${u.pass}8230";
         txt = "Registered Successfully";
          
         await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
         .then((value) 
         async {
          Stat.olduser = false;
          FirebaseFirestore.instance.collection("users").doc(email).set(u.tofire());
         });
      
    } on FirebaseAuthException catch (e) {
       pro.dismiss();
         errorp.showErr(e.message!.swi(), context);
       setState(() {
        btndistxt = "register";
        isbtnactive = true;
        isbtnactive2 = true;
       });
      
    }
      
       //gg
    }
    void cleartxt(){
       usertxtmain.clear();
         passtxt.clear();
         nametxt.clear();
    }
    @override
  void dispose() {
    usertxtmain.dispose();
    passtxt.dispose();
    nametxt.dispose();
    super.dispose();
  }
  @override
  void initState() {
    isbtnactive = false;
    usertxtmain = TextEditingController();
    nametxt = TextEditingController();
    passtxt = TextEditingController();
    usertxtmain.addListener(() {
      setState(() {
        isbtnactive = usertxtmain.text.trim().isNotEmpty && nametxt.text.trim().isNotEmpty && passtxt.text.trim().isNotEmpty; 
      });
      
    });
    
    nametxt.addListener(() {
      setState(() {
        isbtnactive = usertxtmain.text.trim().isNotEmpty && nametxt.text.trim().isNotEmpty && passtxt.text.trim().isNotEmpty; 
      });
    });
    passtxt.addListener(() { 
      setState(() {
        isbtnactive = usertxtmain.text.trim().isNotEmpty && nametxt.text.trim().isNotEmpty && passtxt.text.trim().isNotEmpty; 
      });
    });
    //usertxtmain = usertxt;
    super.initState();
    FlutterNativeSplash.remove();
  }
   
  void ss(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context){
    
    return Scaffold
    (
    extendBodyBehindAppBar: true,
      extendBody: true,
      appBar:  AppBar(backgroundColor: appBarColor, elevation: 0, toolbarHeight: 1),
      backgroundColor: authPageBGcolor,
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
            Text("Register".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black ), ),
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
            // name txtbox
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
                    controller: nametxt,
                    decoration: InputDecoration(
                      
                      border: InputBorder.none,
                      hintText: "Fullname"
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
                 setState(() {
                isbtnactive = false;
                isbtnactive2 = false;
              });

               reguser();}  : null
              ,
              child: Text( isbtnactive?
                "register".toUpperCase(): btndistxt.toUpperCase(),
                style: TextStyle(fontSize: 14)
              )
            ),
            SizedBox(height: 30,),
            //login link
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                Text("already a user? ",
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 99, 100, 100)),
                ),
                 GestureDetector(
                  onTap:isbtnactive2? () => widget.showLoginpage() : null,
                  child: Text
                 (
                  "Login", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, 
                  color: Color.fromARGB(255, 29, 30, 102) ), )
                  ),
               ],
             ),
           
          ]),
        ),
      ),
    );
  }
}


