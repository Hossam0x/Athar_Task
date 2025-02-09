import 'package:athar_task/domain/auth/usecases/get_user.dart';
import 'package:athar_task/presentation/auth/bloc/get_user_info_state.dart';
import 'package:athar_task/service_locator.dart';
import 'package:bloc/bloc.dart';



class UserInfoDisplayCubit extends Cubit<UserInfoDisplayState> {
  UserInfoDisplayCubit() : super(UserInfoLoading());

  void displayUserInfo() async {
  var returnedData = await sl<GetUserUseCase>().call();

  if (isClosed) return; 

  returnedData.fold(
    (error) {
      if (!isClosed) emit(LoadUserInfoFailure());
    },
    (data) {
      if (!isClosed) emit(UserInfoLoaded(user: data));
    },
  );
}

}
