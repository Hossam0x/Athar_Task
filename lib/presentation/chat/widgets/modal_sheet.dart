import 'dart:developer';

import 'package:athar_task/presentation/chat/bloc/background_selection_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/change_chatBox_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/message_cubit.dart';
import 'package:athar_task/presentation/chat/pages/change_background.dart';
import 'package:athar_task/presentation/chat/pages/change_chatbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_horiz, color: Colors.white),
      onPressed: () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final Offset position =
            button.localToGlobal(Offset.zero, ancestor: overlay);

        showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            position.dx,
            position.dy + button.size.height,
            position.dx + button.size.width,
            position.dy + button.size.height + 200,
          ),
          items: [
            const PopupMenuItem<String>(
              value: "changeChatbox",
              child: Text("Change Chatbox"),
            ),
            const PopupMenuItem<String>(
              value: "changeBackground",
              child: Text("Change Background"),
            ),
            const PopupMenuItem<String>(
              value: "deleteChat",
              child: Text(
                "Delete Chat",
                style: TextStyle(
                    color: Colors.red), 
              ),
            ),
          ],
        ).then((value) async {
          if (value == "changeChatbox") {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeChatbox(),
              ),
            );
            context.read<ChatBubbleCubit>().loadSavedColor();
          } else if (value == "changeBackground") {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeBackgroundPage(),
              ),
            );
            context.read<BackgroundCubit>().loadBackground();
          } else if (value == "deleteChat") {}
        });
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Chat"),
        content: const Text("Are you sure you want to delete this chat?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}


class ChatBubbleWrapper extends StatefulWidget {
  final Widget child;
    final String messageId;   

  const ChatBubbleWrapper({super.key, required this.child, required this.messageId});

  @override
  State<ChatBubbleWrapper> createState() => _ChatBubbleWrapperState();
}

class _ChatBubbleWrapperState extends State<ChatBubbleWrapper> {
  final GlobalKey _key = GlobalKey();

  void _showContextMenu(BuildContext context) async {
    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;

    if (renderBox != null && overlay != null) {
      final Offset offset =
          renderBox.localToGlobal(Offset.zero, ancestor: overlay);

      final result = await showMenu(
        requestFocus: true,
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx + renderBox.size.width - 175,   
          offset.dy + renderBox.size.height - 32,   
          offset.dx + renderBox.size.width,
          offset.dy + renderBox.size.height + 28, 
        ),
        items: [
          const PopupMenuItem(
            height: 18, 
            padding: EdgeInsets.symmetric(
                vertical: 1, horizontal: 8), 
            value: "delete",
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, 
              children: [
                Text(
                  "Delete messages",
                  style: TextStyle(fontSize: 14),   
                ),
                SizedBox(width: 20),   
                ImageIcon(
                  
                  AssetImage("assets/vectors/tabler_trash.png"),
                  size: 20,
                  color: Colors.red,
                ), 
              ],
            ),
          ),
        ],
      );

      if (result == "delete") {
              context.read<MessageDisplayCubit>().deleteMessage(widget.messageId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onLongPress: () => _showContextMenu(context),
      child: widget.child,
    );
  }
}
