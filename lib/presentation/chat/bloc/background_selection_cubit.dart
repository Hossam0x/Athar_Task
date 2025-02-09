import 'package:athar_task/presentation/chat/bloc/background_state.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundCubit extends Cubit<BackgroundState> {
  BackgroundCubit() : super(BackgroundInitial());

  static const String _backgroundKey = "chat_background";

  Future<void> loadBackground() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedBackground = prefs.getString(_backgroundKey);
    emit(BackgroundChanged(
        savedBackground ?? "assets/images/Rectangle 22(1).png"));
  }

  Future<void> changeBackground(String newBackground) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundKey, newBackground);
    emit(BackgroundChanged(newBackground));
  }
}
