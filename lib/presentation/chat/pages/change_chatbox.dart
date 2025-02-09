import 'package:athar_task/presentation/chat/bloc/change_chatBox_cubit.dart';
import 'package:athar_task/presentation/chat/pages/change_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChangeChatbox extends StatelessWidget {
  const ChangeChatbox({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      const Color(0xFF6C52FF),
      const Color(0xFFC5048E),
      const Color(0xFFFF5852),
      const Color(0xFFFFDD00),
      const Color(0xFF009022),
      const Color(0xFF00A4B6),
    ];

    return BlocProvider(
      create: (context) => ChatBubbleCubit(),
      child: Scaffold(
        appBar: const mainBar(title: "Change Chatbox"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/cyber-security-modern-internet-browsing-meadow-pattern-with-lighting-effect-dark-background 1.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.read<ChatBubbleCubit>().changeColor(colors[index]);
                },
                child: selectBackgroundWidget(color: colors[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
