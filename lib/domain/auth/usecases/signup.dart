
import 'package:athar_task/core/usecase/usecase.dart';
import 'package:athar_task/data/auth/models/userSignup.dart';
import 'package:athar_task/domain/auth/repository/auth.dart';
import 'package:athar_task/service_locator.dart';
import 'package:dartz/dartz.dart';


class SignupUseCase implements Usecase<Either , UserCreationReq>{
  @override
  Future<Either> call({UserCreationReq? params})async {
    return await sl <AuthRepository>().signup(params!);
  }
  
}
