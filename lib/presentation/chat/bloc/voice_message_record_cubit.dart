import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class VoiceRecorderCubit extends Cubit<String?> {
  final _recorder = AudioRecorder();
  String? _filePath;
  String? url;

  VoiceRecorderCubit() : super(null);

  Future<void> startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      final location = await getApplicationDocumentsDirectory();
      String name = const Uuid().v1(); 
      _filePath = "${location.path}/$name.mp4"; 

      try {
        await _recorder.start(RecordConfig(), path: _filePath!);
        emit("recording");
      } catch (e) {
      }
    } else {
      emit("permission_denied");
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recorder.stop();
      emit("stopped");
      print("⏹️ التسجيل توقف. الملف: $_filePath");
    } catch (e) {
    }
  }

  Future<void> uploadRecording() async {
    if (_filePath == null) return;

    try {
      final file = File(_filePath!);
      final fileName = _filePath!.split('/').last;
      final supabase = Supabase.instance.client;
      
      final response = await supabase.storage.from('voice_messages').upload(
        fileName, 
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      url = supabase.storage.from('voice_messages').getPublicUrl(fileName);
      emit(url);

      // حذف الملف المحلي بعد الرفع
      await file.delete();
    } catch (e) {
    }
  }
}
