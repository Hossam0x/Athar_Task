
import 'package:athar_task/data/chat/model/message.dart';
import 'package:athar_task/data/chat/source/message_firebase_service.dart';
import 'package:athar_task/domain/chat/repository/message.dart';
import 'package:athar_task/service_locator.dart';
import 'package:dartz/dartz.dart';

class MessageRepoImpl extends MessageRepository {
  @override
  Future<Either> sendMessage(Message message) {
    return sl<MessageFirebaseService>().sendMessage(message);
  }
  
  @override
  Stream<Either<String, List<Message>>> getAllmessage() {
    return sl<MessageFirebaseService>().getAllMessages();
  }
  
  @override
  Future<Either> deleteMessage(String? messageid) {
    return sl<MessageFirebaseService>().deleteMessage(messageid);
  }
  
 
}