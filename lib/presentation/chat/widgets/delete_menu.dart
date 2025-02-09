import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showPopupMenu(
    BuildContext context, TapDownDetails details, String message) {
  final position = details.globalPosition; 

  final screenHeight = MediaQuery.of(context).size.height;

  double menuDy =
      position.dy + 10; 

  if (menuDy > screenHeight - 200) {
    menuDy = screenHeight - 200;      
  }

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
        position.dx,
        menuDy, //   
        position.dx + 50,
        menuDy + 50),
    items: [
      PopupMenuItem(
        child: const Text("Delete this message",
            style: TextStyle(color: Colors.red)),
        onTap: () {
        },
      ),
    ],
  );
}
