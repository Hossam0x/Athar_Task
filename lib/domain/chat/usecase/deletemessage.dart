import 'package:athar_task/core/usecase/usecase.dart';
import 'package:athar_task/domain/chat/repository/message.dart';
import 'package:athar_task/service_locator.dart';

import 'package:dartz/dartz.dart';

class DeletemessageUseCase implements Usecase<Either , String> {
  @override
  Future<Either> call({String? params}) {
    return sl<MessageRepository>().deleteMessage(params!);
  }

}

