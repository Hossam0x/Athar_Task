
import 'package:athar_task/data/auth/repository/auth_repo_impl.dart';
import 'package:athar_task/data/auth/source/firebase_api.dart';
import 'package:athar_task/data/chat/repository/message_repo_impl.dart';
import 'package:athar_task/data/chat/source/message_firebase_service.dart';
import 'package:athar_task/domain/auth/repository/auth.dart';
import 'package:athar_task/domain/auth/usecases/get_user.dart';
import 'package:athar_task/domain/auth/usecases/signup.dart';
import 'package:athar_task/domain/chat/repository/message.dart';
import 'package:athar_task/domain/chat/usecase/deletemessage.dart';
import 'package:athar_task/domain/chat/usecase/gatAllmessage.dart';
import 'package:athar_task/domain/chat/usecase/sendmessage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance ;

Future<void> init() async{
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<MessageFirebaseService>(MessageFirebaseServiceImpl());
  sl.registerSingleton<MessageRepository>(MessageRepoImpl());
  sl.registerSingleton<SendmessageUseCase>(SendmessageUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<GetAllMessagesUseCase>(GetAllMessagesUseCase());
  sl.registerSingleton<DeletemessageUseCase>(DeletemessageUseCase());
  


  

  


  


}