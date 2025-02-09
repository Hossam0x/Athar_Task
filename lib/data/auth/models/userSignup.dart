class UserCreationReq {
  String? name;
  String? Email;
  String? Password;
  bool? isTyping = false ;

  UserCreationReq({
    this.name,
    this.Email,
    this.Password,
    this.isTyping ,
  });
}