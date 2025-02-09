import 'dart:async'; // أضف هذه المكتبة لاستخدام Timer
import 'dart:developer';


import 'package:athar_task/common/bloc/button/button_state_cubit.dart';
import 'package:athar_task/data/chat/model/message.dart';
import 'package:athar_task/domain/chat/usecase/sendmessage.dart';
import 'package:athar_task/presentation/chat/bloc/background_selection_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/background_state.dart';
import 'package:athar_task/presentation/chat/bloc/message_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/message_state.dart';
import 'package:athar_task/presentation/chat/bloc/typing_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/typingdetail_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/voice_message_record_cubit.dart';
import 'package:athar_task/presentation/chat/widgets/bubble.dart';
import 'package:athar_task/presentation/chat/widgets/modal_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String? userId;
  const ChatPage({super.key, this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TypingCubit _typingCubit;
  late TypingDetailCubit _detailsCubit;

  @override
  void initState() {
    super.initState();
    _typingCubit = TypingCubit();
    _typingCubit.listenToTypingStatus(widget.userId!);
    _detailsCubit = TypingDetailCubit();
    _detailsCubit.listenToTypingStatus(widget.userId!);
  }

  @override
  void dispose() {
    _typingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TypingDetailCubit>(
          create: (context) => TypingDetailCubit(),
        ),
        BlocProvider(create: (context) => _typingCubit),
        BlocProvider(create: (context) => MessageDisplayCubit()),
        BlocProvider.value(
            value: context.read<BackgroundCubit>()..loadBackground()),
      ],
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.call_outlined, color: Colors.white),
              onPressed: () async {},
            ),
            MyWidget(),
          ],
          title: Row(
            children: [
              Image.asset("assets/images/Ellipse 2.png"),
              const SizedBox(width: 8),
              BlocBuilder<TypingCubit, bool>(
                builder: (context, isTyping) {
                  return const Text(
                    "Maria",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          flexibleSpace: const GradientColorWidget(),
        ),
        body: BlocBuilder<BackgroundCubit, BackgroundState>(
          builder: (context, state) {
            String backgroundImage = state is BackgroundChanged
                ? state.backgroundImage
                : "assets/images/Rectangle 22(1).png";
            return AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: BlocBuilder<MessageDisplayCubit, MessageDisplayState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadMessageFailure) {
                    return Center(child: Text("خطأ: ${state.errorMessage}"));
                  } else if (state is MessageLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 10, right: 15),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubbleWrapper(
                                messageId: state.messages[index].messageid!,
                                child: ChatBubble(
                                  isDeleted: state.messages[index].isdeleted!,
                                  timestamp: DateTime.now(),
                                  message: state.messages[index].msg,
                                  isMe:
                                      state.messages[index].Id == widget.userId,
                                  url: state.messages[index].type == "audio"
                                      ? state.messages[index].audioUrl
                                      : null,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          ),
                        ),
                        BlocBuilder<TypingCubit, bool>(
                          builder: (context, isTyping) {
                            if (isTyping &&
                                widget.userId ==
                                    "G7FsZhNw29VdyhUufN5fecEaGfC2") {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Row(
                                  children: [
                                    ChatBubble(
                                      message: "",
                                      isMe: false, 
                                      timestamp:
                                          DateTime.now(), 
                                      istyping:
                                          true, // 
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox
                                  .shrink();   
                            }
                          },
                        )
                      ],
                    );
                  } else {
                    return const Center(child: Text("لا توجد رسائل بعد."));
                  }
                },
              ),
            );
          },
        ),
        bottomNavigationBar: ChatInputField(userId: widget.userId!),
      ),
    );
  }
}

class GradientColorWidget extends StatelessWidget {
  const GradientColorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFC300FF), Color(0xFF6C52FF)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}

class ChatInputField extends StatefulWidget {
  final String userId;
  const ChatInputField({super.key, required this.userId});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;
  bool _isRecording = false; //
  int _secondsElapsed = 0; //    
  Timer? _timer; //  

  @override
  void initState() {
    super.initState();
    _textController.addListener(_checkText);
  }

  @override
  void dispose() {
    _textController.removeListener(_checkText);
    _textController.dispose();
    _timer?.cancel(); 
    super.dispose();
  }

  void _checkText() {
    setState(() {
      _hasText = _textController.text.isNotEmpty;
    });

    if (_hasText) {
      context.read<TypingCubit>().startTyping(widget.userId);
    } else {
      context.read<TypingCubit>().stopTyping(widget.userId);
    }
  }

  void _startTimer() {
    _secondsElapsed = 0; 
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;    
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();  
    _timer = null;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60; 
    int remainingSeconds = seconds % 60;  
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}'; 
  }

  @override
  Widget build(BuildContext context) {
    final voiceCubit = context.read<VoiceRecorderCubit>();

    return Container(
      height: 120, 
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFFC300FF), Color(0xFF6C52FF)]),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,  
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage("assets/vectors/solar_camera-linear.png"),
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Visibility(
                    visible:
                        !_isRecording,  
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "ًWrite Something ...",
                      ),
                    ),
                    replacement: Image.asset(
                        "assets/vectors/Frame 43.png"), 
                  ),
                ),
                const SizedBox(width: 6),
                if (_hasText)
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 30),
                    onPressed: () {
                      final message = _textController.text;
                      final sendmsgreq = Message(
                        Id: widget.userId,
                        msg: message,
                        createdAt: Timestamp.now(),
                        type: "text",
                      );
                      context.read<ButtonStateCubit>().execute(
                            usecase: SendmessageUseCase(),
                            params: sendmsgreq,
                          );
                      _textController.clear();
                    },
                  )
                else
                  GestureDetector(
                    onLongPress: () async {
                      setState(() {
                        _isRecording = true;  
                      });
                      _startTimer(); //  
                      await voiceCubit.startRecording();
                    },
                    onLongPressUp: () async {
                      setState(() {
                        _isRecording = false;
                      });
                      _stopTimer(); 
                      await voiceCubit.stopRecording();
                      await voiceCubit.uploadRecording();
                      String audioUrl = voiceCubit.state!;
                      final sendmsgreq = Message(
                        audioUrl: audioUrl,
                        Id: widget.userId,
                        msg: audioUrl.isNotEmpty ? "" : "test",
                        createdAt: Timestamp.now(),
                        type: "audio",
                      );

                      context.read<ButtonStateCubit>().execute(
                            usecase: SendmessageUseCase(),
                            params: sendmsgreq,
                          );
                    },
                    child: const Icon(Icons.mic, color: Colors.white, size: 30),
                  ),
              ],
            ),
            if (_isRecording) //      
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${_formatTime(_secondsElapsed)}', //    
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
