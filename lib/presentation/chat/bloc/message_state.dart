import 'package:athar_task/data/chat/model/message.dart';

abstract class MessageDisplayState {}

class MessageLoading extends MessageDisplayState {}

class MessageLoaded extends MessageDisplayState {
  final List<Message> messages;

  MessageLoaded({required this.messages});
}

class LoadMessageFailure extends MessageDisplayState {
  final String errorMessage;

  LoadMessageFailure({required this.errorMessage});
}


