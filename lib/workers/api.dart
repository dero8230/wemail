// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

// ignore: camel_case_types
class errorp
{
  static void showErr(String con , BuildContext context) async
  {
    var errx = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(con), duration: const Duration(seconds: 4),backgroundColor:const Color.fromARGB(255, 175, 58, 54),
     );
     ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(errx);
  }

  static void working(String con , BuildContext context)
  {
    var errx = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(con), duration: const Duration(seconds: 10),backgroundColor:const Color.fromARGB(255, 153, 130, 25),
     );
     ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(errx);
  }

  static void success(String con , BuildContext context) async
  {
    var errx = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(con), duration: const Duration(seconds: 1),backgroundColor:const Color.fromARGB(255, 75, 134, 35),
     );
     ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(errx);
     await Future.delayed(const Duration(seconds: 2));
     await Future.delayed(const Duration(milliseconds: 700));
  }
}