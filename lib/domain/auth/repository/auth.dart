
import 'package:athar_task/data/auth/models/userSigninreq.dart';
import 'package:athar_task/data/auth/models/userSignup.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository{

  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSiginReq user);
  Future<bool> isloggedin();
  Future<Either> getUser();

}
