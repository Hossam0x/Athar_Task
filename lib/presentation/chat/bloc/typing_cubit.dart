import 'dart:async';
import 'package:athar_task/data/chat/source/message_firebase_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class TypingCubit extends Cubit<bool> {
  TypingCubit() : super(false);

  Timer? _typingTimer;
  StreamSubscription<DocumentSnapshot>? _typingSubscription;

  void startTyping(String userId) {
    _updateTypingStatus(userId, true);
    emit(true);

    _typingTimer?.cancel();

    _typingTimer = Timer(const Duration(seconds: 2), () {
      stopTyping(userId);
    });
  }

  void stopTyping(String userId) {
    _updateTypingStatus(userId, false);
    emit(false);
  }

  Future<void> _updateTypingStatus(String userId, bool isTyping) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isTyping': isTyping,
    });
  }

  Future<void> listenToTypingStatus(String userId) async {
    Either<String, List<String>> result =
        await MessageFirebaseServiceImpl().getChatUsersIds();

    result.fold(
      (error) => print("خطأ: $error"),
      (userIds) {
        String? otherUserId = userIds.firstWhere(
          (id) => id != userId,
          orElse: () => '', 
        );

        if (otherUserId.isNotEmpty) {
          _typingSubscription = FirebaseFirestore.instance
              .collection('users')
              .doc(otherUserId)
              .snapshots()
              .listen((doc) {
            if (doc.exists) {
              emit(doc.data()?['isTyping'] ?? false);  
            }
          });
        }
      },
    );
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _typingSubscription?.cancel();
    return super.close();
  }
}
