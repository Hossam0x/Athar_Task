import 'package:flutter/material.dart';

@immutable
abstract class BackgroundState {}

class BackgroundInitial extends BackgroundState {}

class BackgroundChanged extends BackgroundState {
  final String backgroundImage;

  BackgroundChanged(this.backgroundImage);
}
