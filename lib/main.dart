
import 'package:athar_task/common/bloc/button/button_state_cubit.dart';
import 'package:athar_task/presentation/auth/bloc/auth_cubit.dart';
import 'package:athar_task/presentation/auth/bloc/gat_user_info_cubit.dart';
import 'package:athar_task/presentation/auth/pages/login.dart';
import 'package:athar_task/presentation/chat/bloc/background_selection_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/change_chatBox_cubit.dart';
import 'package:athar_task/presentation/chat/bloc/voice_message_record_cubit.dart';
import 'package:athar_task/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized();    
  await setupSupabase();
  await setup(); 
  await init();
  runApp(const ChatApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();     
  await setupFirebase();   
}



Future<void> setupFirebase() async {
  await Firebase.initializeApp();   
}

Future<void> setupSupabase() async {
  await Supabase.initialize(
    url: 'https://pjoqyywyseqmkqnkletd.supabase.co', 
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBqb3F5eXd5c2VxbWtxbmtsZXRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg5Mjk1OTksImV4cCI6MjA1NDUwNTU5OX0.GNgASEiJUEd4PzBsFJVMNAF129C3PSwXShD2pzQOX5o', // ✅ استبدلها بمفتاح الـ API الخاص بك
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(
          create: (context) => BackgroundCubit()..loadBackground(),
        ),
        BlocProvider(create: (context) => ButtonStateCubit()),
        BlocProvider(create: (context) => UserInfoDisplayCubit()),
        BlocProvider(create: (context) => ChatBubbleCubit()),
        BlocProvider(create: (context) => VoiceRecorderCubit()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(), //      
      ),
    );
  }
}
