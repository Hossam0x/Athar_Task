import 'dart:async';

import 'package:athar_task/data/chat/source/message_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypingDetailCubit extends Cubit<Map<String, Object>> {
  TypingDetailCubit() : super({'otherUserId': '', 'isTyping': false});

  StreamSubscription? _typingSubscription;

  Future<void> listenToTypingStatus(String userId) async {
    Either<String, List<String>> result =
        await MessageFirebaseServiceImpl().getChatUsersIds();

    result.fold(
      (error) => print("خطأ: $error"),
      (userIds) {
        String? otherUserId =
            userIds.firstWhere((id) => id != userId, orElse: () => '');

        if (otherUserId.isNotEmpty) {
          _typingSubscription = FirebaseFirestore.instance
              .collection('users')
              .doc(otherUserId)
              .snapshots()
              .listen((doc) {
            if (doc.exists) {
              bool isTyping = doc.data()?['isTyping'] ?? false;
              emit({
                'otherUserId': otherUserId,
                'isTyping': isTyping,
              });
            }
          });
        }
      },
    );
  }

  @override
  Future<void> close() {
    _typingSubscription?.cancel();
    return super.close();
  }
}
