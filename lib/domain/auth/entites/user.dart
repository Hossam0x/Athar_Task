class UserEntity {
  final String userId;
  final String name;
  final String email;
  final bool? isTyping ;

  UserEntity({
    required this.userId,
    required this.name,
    required this.email,
    this.isTyping
  });

 
}
