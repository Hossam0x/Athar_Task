import 'package:athar_task/core/usecase/usecase.dart';
import 'package:athar_task/data/chat/model/message.dart';
import 'package:athar_task/domain/chat/repository/message.dart';
import 'package:athar_task/service_locator.dart';

import 'package:dartz/dartz.dart';

class GetAllMessagesUseCase implements Usecase<Stream<Either<String, List<Message>>>, Message> {
  @override
  Future<Stream<Either<String, List<Message>>>> call({Message? params}) async {
    return sl<MessageRepository>().getAllmessage();
  }
}

