// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, implementation_imports, unnecessary_import, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wemail/constants.dart';
import 'package:wemail/views/messege.dart';
import 'package:wemail/workers/Stat.dart';
import 'package:wemail/workers/api.dart';
import 'package:wemail/views/login_page.dart';
import 'package:ndialog/ndialog.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({Key? key, required this.user }) : super(key: key);
  static const rout = "home";
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  var fstore = FirebaseFirestore.instance.collection("messeges");
  var pswd = TextEditingController();
  String? name="";
  String cash ="";
  bool isbtnactive = true;
  void delaccc(String pass) async{
    try {
      pswd.clear();
      var password = "${pass}8230";
      var credential = EmailAuthProvider.credential(email: widget.user.email! , password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
      isbtnactive = false;
      errorp.working("Deleting Acount....", context);
      await FirebaseAuth.instance.currentUser!.delete().then((value)  {errorp.success("Account Deleted", context); 
      FirebaseFirestore.instance.collection("users").doc(name).delete();
      });
    } on FirebaseAuthException catch (e) {
       errorp.showErr(e.message!.swi().pswd(), context);
    }
    
     

    isbtnactive = true;
  }
  @override
  void dispose() {
    pswd.dispose();
    super.dispose();
  }
  @override
     void initState(){
    name = FirebaseAuth.instance.currentUser!.email;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {   
      if(Navigator.canPop(context)){
        Navigator.pop(context);
        if (Stat.olduser) {
          errorp.success("Logged in as $name", context);
        } else {
          errorp.success("Registration Sucessful", context);
        }
        
        
      }  
      FlutterNativeSplash.remove();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: appBarColor,
        elevation: 1,
        title: FutureBuilder(future:FirebaseFirestore.instance.collection("users").doc(name).get() ,
          builder: 
        (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var fname = snapshot.data["name"] as String;
            return  Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FloatingActionButton.small(onPressed: (){ showChangeDetails();}, 
                  elevation: 0, backgroundColor: Colors.grey,
                  foregroundColor: Colors.white70,
                  child: Icon(Icons.person, size: 35,),
                  ),
                ),
                Text(maxLines: 1, fname.split(' ')[0] , 
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), ),
              ],
            );
          }
          return CircularProgressIndicator();
         },),
        actions: [ IconButton(onPressed: (() => 
        logout()), 
        icon: Icon(Icons.logout, color: Colors.black,)) ],
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row( children: [ Expanded(
        child: Align( alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Draggable(
              childWhenDragging: SizedBox.shrink(),
              feedback: FloatingActionButton(onPressed: (){}, heroTag: "fl1",
              child: Icon(Icons.chat,size: 30,), ),
              child: FloatingActionButton(onPressed: ()=>showNewMessege(), heroTag: "fl2",
              child: Icon(Icons.chat,size: 30,), ),
            ),
          )),
      ), Align(alignment: Alignment.bottomRight, 
      child:Padding(
        padding: const EdgeInsets.only(right: 10),
        child: FloatingActionButton( 
          backgroundColor: Colors.red, onPressed: () => showdelconfirm(), 
                  child: Icon(Icons.delete,
                  color: Colors.white, size: 40,),),
      ))],),
      backgroundColor: backgroundColor
      , body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: 
          [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("messeges")
                .where("owners", arrayContains: name)
                .orderBy("time", descending: true).snapshots(),
                builder: ((context, snapshot)
                {
                  if(snapshot.hasData){
                    final users = snapshot.data!.docs;
                    List<String> unique = [];
                    List<Padding> usersbtn = [];
                    for (var user in users) {
                      var docid = user.id;
                      var read = user.get("read") as bool;
                      final messege = user.get("messege") as String;
                      final reciever = user.get("reciever") as String;
                      var sender =  user.get("sender") as String;
                      final mainsender = sender;
                      if(sender == name)
                      {
                        sender = user.get("reciever");
                      }
                      final btn = Padding( padding: EdgeInsets.only(bottom: 2),
                        child: 
                      MaterialButton(splashColor: Colors.grey, onPressed: (){
                       Navigator.of(context).push( MaterialPageRoute(builder: ((context) => 
                       Messeges(receiver: sender))));
                       if (!read && reciever == name) {
                         fstore.doc(docid).update({'read': true});
                       }
                       }, height: 60, color: backgroundColor,
                       elevation: 0,
                       child: Padding(
                         padding: const EdgeInsets.only(right: 20),
                         child: Row(
                           children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Align( alignment: Alignment.centerLeft,
                                child: Icon(Icons.person_rounded,
                                 color: read||mainsender == name? Colors.black54: Colors.black ,)),
                            ),
                             Expanded(
                               child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Align(alignment: Alignment.topLeft,
                                    child: Container(
                                      constraints:  BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width - 100
                                            ),
                                      child: Text( sender,maxLines: 1,overflow: TextOverflow.fade,
                                       style: TextStyle(fontSize: 20,
                                      color: read||mainsender == name? Colors.black54 : Colors.black87,
                                       fontWeight: FontWeight.bold)),
                                    )),
                                   Align(alignment: Alignment.bottomLeft, 
                                   child: Row(
                                     children: [
                                       mainsender == name? Text("you: ", 
                                       style: TextStyle(color:Colors.grey ),): 
                                       SizedBox.shrink(),
                                       Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width - 100
                                            ),
                                         child: Text( messege,overflow: TextOverflow.ellipsis,
                                         maxLines: 1, style:
                                          TextStyle(fontSize: read||mainsender == name? 15: 16,
                                          fontWeight:read||mainsender == name? FontWeight.normal: FontWeight.bold ,
                                         color: read||mainsender == name? Colors.grey: Colors.black
                                          )),
                                       ),
                                     ],
                                   )),
                                   
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                       ));
                       if (!unique.contains(sender)) {
                          usersbtn.add(btn);
                        unique.add(sender);
                       }
                       
                        
                    }
                    return ListView.builder(itemCount: usersbtn.length, itemBuilder: (context, index){
                      return usersbtn[index];
                    });
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })
                )
            )     
          ],
        ),
      ),
      
    );
  }
  void showdelconfirm(){
     DialogBackground
       (
        barrierColor: Color.fromARGB(0, 0, 0, 0),
        blur: 10,
        dialog: NAlertDialog
        (
          dismissable: false,
          title: Text("Account Warning"),
          content: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Text("are you sure you want to delete your account?"),
              TextField(obscureText: true, controller: pswd,
              decoration: InputDecoration(hintText: "Password"),
               )
            ],
          ),
          actions: 
          [
            TextButton(onPressed: ((){ Navigator.of(context).pop();}), 
            child: Text("cancel")),
            TextButton(onPressed: (() { delaccc(pswd.text); Navigator.of(context).pop();}), 
            child:Text("confirm")),
          ],
        ),
       ).show(context);
  }

  void showNewMessege(){
    DialogBackground( dismissable: true, blur: 0.9, dialog: 
    NDialog(title: Row(
      children: [
        Icon(Icons.chat_rounded)
        ,Text("New Messege"),
      ],
    ),
      content: SizedBox(
    height: 600.0, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("users").get(),
      builder: ( context,  snapshot)
       { 
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(
                    child: CircularProgressIndicator(),
                  );
        }

return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data!.size,
        itemBuilder: ( context, index) {
          if (snapshot.data!.docs[index]["email"] == FirebaseAuth.instance.currentUser!.email) {
            return SizedBox.shrink();
          }
          var sender = snapshot.data!.docs[index]["email"];
          return  MaterialButton(elevation: 0,
            splashColor: Colors.grey, onPressed: () {
                       
                       Navigator.of(context).push( MaterialPageRoute(builder: ((context) => 
                         Messeges(receiver: sender))));
                       }, height: 60, color: Color.fromARGB(255, 255, 255, 255),
                       child: Row(
                         children: [
                          Icon(Icons.person),
                           Text(snapshot.data!.docs[index]["email"]),
                         ],
                       )
                       );
          
          });
       },
    )), )
     ,).show(context);
  }

   void logout(){
    DialogBackground
    ( 
      barrierColor: Color.fromARGB(83, 0, 0, 0),
      dialog: NDialog( 
      title: Text("Logout"),
      content: Text("your about to logout"),
      actions: [
        TextButton(onPressed: ((){ Navigator.of(context).pop();}), 
            child: Text("cancel")),
            TextButton(onPressed: (() {
              Navigator.of(context).pop();
            FirebaseAuth.instance.signOut();
            }), 
            child:Text("logout")),
      ],
    ) ,
    ).show(context);

  }

  void showChangeDetails(){
    var u = TextEditingController();
    var fname = TextEditingController();
    var psw = TextEditingController();
    DialogBackground
       (
        barrierColor: Color.fromARGB(0, 0, 0, 0),
        blur: 10,
        dialog: NAlertDialog
        (
          dismissable: false,
          title: Text("Edit Account"),
          content: Column(mainAxisSize: MainAxisSize.min,
            children: [

              TextField( controller: u,
              decoration: InputDecoration(hintText: "Username"),
               ),

               TextField( controller: fname,
              decoration: InputDecoration(hintText: "Fullname"),
               ),

               TextField( controller: psw,
               obscureText: true,
              decoration: InputDecoration(hintText: "Enter Password"),
               ),
            ],
          ),
          actions: 
          [
            TextButton(onPressed: ((){ 
              psw.dispose();
              u.dispose();
              fname.dispose();
              Navigator.of(context).pop();}), 
            child: Text("cancel")),
            TextButton(onPressed: ((){
              psw.dispose();
              u.dispose();
              fname.dispose();
                Navigator.of(context).pop(); 
                }), 
            child:Text("confirm")),
          ],
        ),
       ).show(context);
  }
  // Route messagePage( Widget user, String receiver)
  // {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => Messeges(user: user, receiver: receiver),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child){
  //       const begin = Offset(0.0, 1.0);
  //        const end = Offset.zero;
  //        const curve = Curves.ease;
  //        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)) ;
  //        final offsetAnimation = animation.drive(tween);
  //       return SlideTransition(
  //         position: offsetAnimation,
  //          child: child,
  //          );
  //     }
  //     );
  // }

}

