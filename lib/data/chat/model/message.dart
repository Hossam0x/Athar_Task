import 'package:cloud_firestore/cloud_firestore.dart';

enum Type { text, image, audio }

class Message {
  Message({
    required this.msg,
    required this.Id,
    required this.type,
    this.audioUrl,
    this.createdAt,
    this.isdeleted = false,
    this.messageid ,

  });

  final String msg;
  final String Id;
  final String? type;
  final String? audioUrl;
  final Timestamp? createdAt;
  final bool? isdeleted ;
  final String? messageid; 

  Message.fromJson(Map<String, dynamic> json)
      : Id = json['senderId'].toString(),
      messageid = json['messageId'].toString() ,
        msg = json['message'].toString(),
        isdeleted= json['isdeleted'],
        type = json['type'].toString(),
        audioUrl = json['audioUrl'],
        createdAt = json['createdAt'] != null
            ? (json['createdAt'] is Timestamp
                ? json['createdAt']
                : Timestamp.fromMillisecondsSinceEpoch(json['createdAt']))
            : null;

  Map<String, dynamic> toJson() {
    return {
      'isdeleted': isdeleted,
      'senderId': Id,
      'message': msg,
      'type': type, 
      'messageId':messageid,

      if (audioUrl != null) 'audioUrl': audioUrl,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
