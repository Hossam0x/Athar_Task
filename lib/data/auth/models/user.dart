import 'dart:convert';

import 'package:athar_task/domain/auth/entites/user.dart';


class UserModel {
  final String userId;
  final String name;
  final String email;
  bool isTyping;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.isTyping = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'isTyping': isTyping,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      isTyping: map['isTyping'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      isTyping: isTyping
    );
  }
}
