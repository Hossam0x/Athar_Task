
import 'package:equatable/equatable.dart';

abstract class VoiceState extends Equatable {
  @override
  List<Object> get props => [];
}

class VoiceInitial extends VoiceState {}

class RecordingState extends VoiceState {}

class RecordedState extends VoiceState {
  final String filePath;
  RecordedState({required this.filePath});
}

class SendingState extends VoiceState {}

class SentState extends VoiceState {}

class VoiceError extends VoiceState {
  final String message;
  VoiceError(this.message);
  
  @override
  List<Object> get props => [message];
}
