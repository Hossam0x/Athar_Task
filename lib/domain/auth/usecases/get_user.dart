import 'package:athar_task/core/usecase/usecase.dart';
import 'package:athar_task/domain/auth/repository/auth.dart';
import 'package:athar_task/service_locator.dart';

import 'package:dartz/dartz.dart';



class GetUserUseCase implements Usecase<Either , dynamic>{
  @override
  Future<Either> call({params})async {
    return await sl<AuthRepository>().getUser() ;
  }

 
}
