import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:grouptalk/core/network/network_info.dart';
import 'package:grouptalk/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:grouptalk/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';
import 'package:grouptalk/features/authentication/domain/usecases/login_user.dart';
import 'package:grouptalk/features/authentication/domain/usecases/logout_user.dart';
import 'package:grouptalk/features/authentication/domain/usecases/register_user.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //* ========================
  //* Firebase
  //* ========================
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //* ========================
  //* Network info
  //* ========================
  // Network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  // Connection checker
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  //* ========================
  //* Authentication Featur
  //* ========================

  // Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(loginUser: sl(), registerUser: sl(), logoutUser: sl()),
  );

  // Use cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(authRepository: sl()));

  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(authRepository: sl()),
  );

  sl.registerLazySingleton<LogoutUser>(() => LogoutUser(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
}
