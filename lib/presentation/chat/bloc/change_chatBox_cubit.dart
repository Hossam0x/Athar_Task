import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBubbleCubit extends Cubit<Color> {
  ChatBubbleCubit() : super(Colors.blue) {
    loadSavedColor();
  }

  Future<void> loadSavedColor() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedColor = prefs.getInt('chatBubbleColor');
    if (savedColor != null) {
      emit(Color(savedColor));
    }
  }

  Future<void> changeColor(Color newColor) async {
    emit(newColor);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chatBubbleColor', newColor.value);
  }
}