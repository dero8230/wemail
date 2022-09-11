// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:wemail/workers/api.dart';

class Messeges extends StatefulWidget {
  final String receiver;
  const Messeges({Key? key, required this.receiver}) : super(key: key);
  @override
  State<Messeges> createState() => _MessegesState();
}

class _MessegesState extends State<Messeges> {
  late Stream stream;
  var fstore = FirebaseFirestore.instance.collection("messeges");
  late final String currentUser;
  bool isbtnactive = true;
  var messagebox =  TextEditingController();
   final ScrollController _controller = ScrollController();
  void sendmessege()
  {
    
    var message = messagebox.text.trim();
    messagebox.clear();
    if(message.isEmpty) return;
    var receiver = widget.receiver;
    FirebaseFirestore.instance
    .collection("messeges").add(formatMessege(message, receiver))
    .then((value) async{ 
      errorp.success("messege sent", context); 
    });
  }
 Map<String, dynamic> formatMessege(String message, String receiver) =>
 {
    'messege': message,
    'reciever': receiver,
    'sender': FirebaseAuth.instance.currentUser!.email,
    'time': Timestamp.now(),
    'bond': FirebaseAuth.instance.currentUser!.email!+receiver,
    'owners': [
       FirebaseAuth.instance.currentUser!.email,
       receiver
    ],
    'read': false
 };
 @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser!.email!;
    stream = FirebaseFirestore.instance.collection("messeges")
              .where("bond", whereIn: [currentUser+widget.receiver, widget.receiver+currentUser] )
              .orderBy("time", descending: false).snapshots();
     stream.listen((event) 
     { 
       scrollDown();
       for (var dat in event.docChanges)
       {
         var docid = dat.doc.id;
         var read = dat.doc.get("read") as bool;
         final reciever = dat.doc.get("reciever") as String;
         if (!read && reciever == currentUser) {
           fstore.doc(docid).update({'read': true});
         }
       }
      
     });         
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    messagebox.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom: kIsWeb? 20: 0),
        child: IconButton(splashColor: Colors.lightBlue, 
                  color: Color.fromARGB(255, 10, 59, 221), highlightColor: Colors.green, 
                  onPressed: (){ sendmessege();}, 
                  icon: const Icon(Icons.send)),
      ),
      backgroundColor: Colors.grey[350],
      appBar:  AppBar(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor:  Colors.grey[200],
        toolbarHeight: 50,
        title: Text( widget.receiver, 
                          style: TextStyle(fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black)),
        actions: [], ),
        body: Column
        ( crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
          children: 
          [
            Expanded
            (
              child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("messeges")
              .where("bond", whereIn: [currentUser+widget.receiver, widget.receiver+currentUser] )
              .orderBy("time", descending: false).snapshots(),
              builder: ((context, snapshot)
              {
                if(snapshot.hasData){
                  if (snapshot.data!.docChanges.isNotEmpty) {
                    
                  }
                  final users = snapshot.data!.docs;
                  List<Container> usersbtn = [];
                  for (var user in users) {
                   final messege = user.get("messege") as String;
                    final sender =  user.get("sender") as String;
                    final time  = user.get("time") as Timestamp;
                    final docid = user.id;
                     final btn = Container(
                      padding:  EdgeInsets.only(left:sender == currentUser? 100: 10,
                      right:sender == currentUser? 10:100, bottom: 2),
                      child:
                     Align(
                      alignment: sender == currentUser? Alignment.topRight: Alignment.topLeft,
                       child: GestureDetector(
                        onLongPressStart: (details) {
                         showminiMenu(details, sender, time, docid);},
                         child: MaterialButton(padding: EdgeInsets.zero,
                         minWidth: 50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: sender == currentUser? Color.fromARGB(255, 10, 59, 221): Color.fromARGB(255, 228, 229, 230),
                           onPressed:isbtnactive? () { } : null,
                           child: Padding(
                             padding: const EdgeInsets.only(right: 8, left: 8, top: 5, bottom: 5),
                             child: Text( messege, style: TextStyle(
                               color:sender == currentUser? Colors.white: Colors.black
                              , fontSize: 15,
                              )),
                           ),
                         ),
                       )  ,
                     ));
                     usersbtn.add(btn);
                  }
                  return SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                    reverse: true,
                    controller: _controller,
                    child: ListView.builder(
                      keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.manual ,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true, itemCount: usersbtn.length, itemBuilder: (context, index){
                      return usersbtn[index];
                      
                    }),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })
              )
            ),
            
            Row
            (
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,bottom: 15, right: 70),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(214, 214, 214, 1)),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(style: TextStyle(fontSize: 20),
                        autofocus: false,
                        minLines: 1,
                        controller: messagebox,
                        maxLines: 3,
                        inputFormatters: [LengthLimitingTextInputFormatter(300)],
                        keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "messege"
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
              ],
            )
          ],
        ),);
  }

  Future<void> showminiMenu(LongPressStartDetails details, String sender, Timestamp time, String docid)
  async {
    FocusScope.of(context).unfocus();
    var tmx = time.toDate().toLocal();
    if (sender != FirebaseAuth.instance.currentUser!.email) 
    {
     await  showMenu(context: context, 
    constraints: BoxConstraints(maxWidth: 75),
    position: RelativeRect.fromLTRB(details.globalPosition.dx, 
    details.globalPosition.dy, details.globalPosition.dx, details.globalPosition.dy), 
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    items: [ PopupMenuItem( child: Text("${tmx.hour}:${tmx.minute}", maxLines: 1,)),]);
    }else{
    var opt = await showMenu(context: context, 
    constraints: BoxConstraints(maxWidth: 60),
    initialValue: 0,
    position: RelativeRect.fromLTRB(details.globalPosition.dx, 
    details.globalPosition.dy, details.globalPosition.dx, details.globalPosition.dy), 
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    items: [ PopupMenuItem( 
      value: 1,
      height: 40, child: Icon(Icons.delete)),]);
    if(opt == 1)
    {
      delmessege(docid);
    }
    }

    
  }

  void delmessege(String docid)
  {
    DialogBackground
    ( 
      barrierColor: Colors.transparent,
      dialog: NDialog( 
      title: Text("Delete Messege"),
      content: Text("delete messege? this action cannot be reversed"),
      actions: [
        TextButton(onPressed: ((){ Navigator.of(context).pop();}), 
            child: Text("cancel")),
            TextButton(onPressed: (() {
            Navigator.of(context).pop(); 
            FirebaseFirestore.instance.collection("messeges").doc(docid).delete();
            }), 
            child:Text("delete")),
      ],
    ) ,
    ).show(context);

    
  }

  void scrollDown(){
    _controller.jumpTo(_controller.position.minScrollExtent);
  }

 
}

