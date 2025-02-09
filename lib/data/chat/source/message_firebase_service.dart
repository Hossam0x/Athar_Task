import 'dart:io';
import 'package:athar_task/data/chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

abstract class MessageFirebaseService {
  Future<Either<String, String>> sendMessage(Message message,
      {File? audioFile});
  Stream<Either<String, List<Message>>> getAllMessages();
  Future<Either> deleteMessage(String? messageid) ;

}

class MessageFirebaseServiceImpl extends MessageFirebaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<Either<String, String>> sendMessage(Message message,
      {File? audioFile}) async {
    try {
      String id = _firebaseAuth.currentUser?.uid ?? '';

      String? audioUrl;
      if (audioFile != null) {
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${basename(audioFile.path)}';

        try {
          final filePath = await _supabase.storage
              .from('voice_messages')
              .upload(fileName, audioFile);

          audioUrl =
              _supabase.storage.from('voice_messages').getPublicUrl(filePath);
        } catch (e) {
          return Left("فشل في رفع الصوت إلى Supabase: ${e.toString()}");
        }
      }

      var messagedata = {
        'isdeleted': message.isdeleted,
        'type': message.type,
        'senderId': message.Id,
        'message': message.msg,
        if (message.audioUrl != null)
          'audioUrl': message.audioUrl, // 
        'CreatedAt': FieldValue.serverTimestamp(),
      };

      DocumentReference docRef =
          await _firebaseFirestore.collection('messages').add(messagedata);

      await docRef.update({'messageId': docRef.id});
      return Right("Message sent");
    } catch (e) {
      return Left("Failed to send message: ${e.toString()}");
    }
  }

  @override
  Stream<Either<String, List<Message>>> getAllMessages() {
    try {
      return _firebaseFirestore
          .collection('messages')
          .orderBy('CreatedAt', descending: false) 
          .snapshots()
          .map((snapshot) {
        List<Message> messages = snapshot.docs.map((doc) {
          return Message.fromJson(doc.data());
        }).toList();

        return Right(messages);
      });
    } catch (e) {
      return Stream.value(Left("Failed to load messages"));
    }
  }
  
  @override
  Future<Either<String, String>> deleteMessage(String? messageid) async  {
    try {
    if (messageid == null || messageid.isEmpty) {
      return Left("Message ID غير صالح");
    }

await _firebaseFirestore.collection('messages').doc(messageid).update({
        'isdeleted': true,
      });    
    return Right("تم حذف الرسالة بنجاح");
  } catch (e) {
    return Left("فشل في حذف الرسالة: ${e.toString()}");
  }
  }

  Future<Either<String, List<String>>> getChatUsersIds() async {
  try {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('users')
        .limit(2)
        .get();

    if (querySnapshot.docs.length < 2) {
      return Left("لم يتم العثور على مستخدمين كافيين.");
    }

    List<String> userIds = querySnapshot.docs.map((doc) => doc.id).toList();

    return Right(userIds);
  } catch (e) {
    return Left("فشل في جلب المستخدمين: ${e.toString()}");
  }
}

}
