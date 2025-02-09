import 'package:athar_task/data/chat/model/message.dart';
import 'package:athar_task/domain/chat/usecase/deletemessage.dart';
import 'package:athar_task/domain/chat/usecase/gatAllmessage.dart';
import 'package:athar_task/presentation/chat/bloc/message_state.dart';
import 'package:athar_task/service_locator.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MessageDisplayCubit extends Cubit<MessageDisplayState> {
  final GetAllMessagesUseCase _getAllMessagesUseCase = sl<GetAllMessagesUseCase>();
  final DeletemessageUseCase _deleteMessageUseCase = sl<DeletemessageUseCase>();
  Stream<Either<String, List<Message>>>? _messagesStream;

  MessageDisplayCubit() : super(MessageLoading()) {
    _loadMessages();
  }

  void _loadMessages() async { //   
    final futureStream = await _getAllMessagesUseCase.call(); //  
    _messagesStream = futureStream;

    _messagesStream?.listen((either) {
      either.fold(
        (error) {
          emit(LoadMessageFailure(errorMessage: error));
        },
        (messages) {
          emit(MessageLoaded(messages: messages));
        },
      );
    });
  }

   Future<void> deleteMessage(String messageId) async {
    final result = await _deleteMessageUseCase.call(params:  messageId);
    result.fold(
      (error) {
        emit(LoadMessageFailure(errorMessage: error));
      },
      (_) {
        _loadMessages(); //    
      },
    );
  }


}
