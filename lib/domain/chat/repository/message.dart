import 'package:athar_task/data/chat/model/message.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository {

  Future<Either> sendMessage(Message message) ;
  Stream<Either<String, List<Message>>> getAllmessage();  
  Future<Either> deleteMessage(String? messageid) ;

}