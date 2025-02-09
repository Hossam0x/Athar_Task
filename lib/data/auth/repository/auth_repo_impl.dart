
import 'package:athar_task/data/auth/models/user.dart';
import 'package:athar_task/data/auth/models/userSigninreq.dart';
import 'package:athar_task/data/auth/models/userSignup.dart';
import 'package:athar_task/data/auth/source/firebase_api.dart';
import 'package:athar_task/domain/auth/repository/auth.dart';
import 'package:athar_task/service_locator.dart';
import 'package:dartz/dartz.dart';



class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(UserCreationReq user) {
    return sl<AuthFirebaseService>().signup(user);
  }

 

  @override
  Future<Either> signin(UserSiginReq user) {
    return sl<AuthFirebaseService>().signin(user);
  }
  
  @override
  Future<Either> getUser()async {
     var user = await sl<AuthFirebaseService>().getUser();
    return user.fold(
      (error){
        return Left(error);
      },
      (data){
        return Right(
          UserModel.fromMap(data).toEntity()
        );
      }
      );
  }
  
  @override
  Future<bool> isloggedin() {
    // TODO: implement isloggedin
    throw UnimplementedError();
  }
  
  @override
  Future<Either> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }


  
  
}
