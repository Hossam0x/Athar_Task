
import 'package:athar_task/domain/auth/entites/user.dart';

abstract class UserInfoDisplayState {
}

class UserInfoLoaded extends UserInfoDisplayState{
  final UserEntity user ;

  UserInfoLoaded({required this.user}); 
}

class UserInfoLoading extends UserInfoDisplayState{}

class LoadUserInfoFailure extends UserInfoDisplayState{}