import 'package:flutter/material.dart';

class AppNavigator {

 static void push(BuildContext context , Widget Widget){
    Navigator.push(context, 
    MaterialPageRoute(builder: (context) => Widget)
    );
    
  }
  static void pushReplacement(BuildContext context , Widget Widget){
    Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context) => Widget)
    );
  }

  static void pushAndRemove(BuildContext context , Widget new_page){
    Navigator.pushAndRemoveUntil(
      context,
     MaterialPageRoute(builder: (context) => new_page),
      (Route<dynamic> route ) => false // إزالة جميع الشاشات
      
      );
  }
}