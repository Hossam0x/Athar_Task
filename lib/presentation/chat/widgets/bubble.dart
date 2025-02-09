import 'package:athar_task/presentation/chat/bloc/change_chatBox_cubit.dart';
import 'package:athar_task/presentation/chat/widgets/voice_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // استيراد المكتبة
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String senderName;
  final String senderImage;
  final DateTime timestamp;
  final String? url;
  final bool isDeleted;
  final bool? istyping;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      this.senderName = "Maria",
      this.senderImage = "assets/images/Ellipse 2.png",
      required this.timestamp,
      this.url,
      this.isDeleted = false,
      this.istyping});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.bottomRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 4, left: 10),
              child: Column(
                children: [
                  Image.asset(
                    isMe
                        ? "assets/images/Ellipse 1.png" 
                        : senderImage, 
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 0),
                  child: Text(
                    isMe
                        ? "Assistant" 
                        : senderName, 
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: istyping == true
                        ? null
                        : 300, // 
                    child: BlocBuilder<ChatBubbleCubit, Color>(
                      builder: (context, chatBubbleColor) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDeleted
                                ? Colors.grey[600] 
                                : (isMe ? chatBubbleColor : Colors.grey[300]),
                            borderRadius: BorderRadius.only(
                              topLeft: isMe
                                  ? const Radius.circular(10)
                                  : Radius.zero,
                              topRight: isMe
                                  ? Radius.zero
                                  : const Radius.circular(10),
                              bottomLeft: const Radius.circular(10),
                              bottomRight: const Radius.circular(10),
                            ),
                          ),
                          child: isDeleted
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.block, //
                                      color: Colors.white, //
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "You deleted this message",
                                      style: TextStyle(
                                        color: Colors.white, //
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : (istyping == true 
                                  ? const SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 24.0,  
                                    )
                                  : (url != null && url!.isNotEmpty
                                      ? Row(
                                          children: [
                                            Image.asset(
                                                "assets/images/Ellipse 2.png"),
                                            Expanded(
                                                child: VoiceMessageWidget(
                                                    url: url!)),
                                          ],
                                        )
                                      : Text(
                                          message,
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ))),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatTimestamp(timestamp),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute < 10 ? '0${timestamp.minute}' : timestamp.minute}";
  }
}
