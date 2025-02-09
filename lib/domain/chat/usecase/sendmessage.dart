import 'package:athar_task/core/usecase/usecase.dart';
import 'package:athar_task/data/chat/model/message.dart';
import 'package:athar_task/domain/chat/repository/message.dart';
import 'package:athar_task/service_locator.dart';

import 'package:dartz/dartz.dart';

class SendmessageUseCase implements Usecase<Either , Message> {
  @override
  Future<Either> call({Message? params}) {
    return sl<MessageRepository>().sendMessage(params!);
  }
}