import 'package:athar_task/presentation/chat/bloc/background_selection_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/change_chatBox_cubit.dart';
import 'package:athar_task/presentation/chat/widgets/chat_bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeBackgroundPage extends StatelessWidget {
  const ChangeBackgroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackgroundCubit(),
      child: Scaffold(
        appBar: const mainBar(title: "Change Background"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/cyber-security-modern-internet-browsing-meadow-pattern-with-lighting-effect-dark-background 1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    selectBackgroundWidget(
                      image: "assets/images/Rectangle 22.png",
                    ),
                    SizedBox(width: 10),
                    selectBackgroundWidget(
                      image: "assets/images/Rectangle 22(1).png",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class mainBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const mainBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC300FF), Color(0xFF6C52FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class selectBackgroundWidget extends StatelessWidget {
  final String? image;
  final Color? color;

  const selectBackgroundWidget({super.key, this.image, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 180,
        height: 207,
        child: Column(
          children: [
            const Spacer(),
            color != null
                ? chatBublewidget(color: color)
                : Image(
                    image: AssetImage(image!),
                  ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (image == null || image == "") {
                  context.read<ChatBubbleCubit>().changeColor(color!);
                } else {
                  context.read<BackgroundCubit>().changeBackground(image!);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C52FF), Color(0xFFC300FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  constraints:
                      const BoxConstraints(minWidth: 80, minHeight: 40),
                  child: const Text(
                    "change",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
