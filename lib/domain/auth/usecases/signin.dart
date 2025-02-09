import 'package:athar_task/core/usecase/usecase.dart';
import 'package:athar_task/data/auth/models/userSigninreq.dart';
import 'package:athar_task/domain/auth/repository/auth.dart';
import 'package:athar_task/service_locator.dart';

import 'package:dartz/dartz.dart';


class SigninUseCase implements Usecase<Either , UserSiginReq>{
  @override
  Future<Either> call({UserSiginReq? params})async {
    return await sl <AuthRepository>().signin(params!);
  }
  
}
