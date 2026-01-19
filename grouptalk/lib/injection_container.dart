import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:grouptalk/core/network/network_info.dart';
import 'package:grouptalk/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:grouptalk/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';
import 'package:grouptalk/features/authentication/domain/usecases/get_auth_state.dart';
import 'package:grouptalk/features/authentication/domain/usecases/login_user.dart';
import 'package:grouptalk/features/authentication/domain/usecases/logout_user.dart';
import 'package:grouptalk/features/authentication/domain/usecases/register_user.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/room/data/datasources/room_remote_data_source.dart';
import 'package:grouptalk/features/room/data/repositories/room_repository_impl.dart';
import 'package:grouptalk/features/room/domain/repositories/room_repository.dart';
import 'package:grouptalk/features/room/domain/usecases/create_room.dart';
import 'package:grouptalk/features/room/domain/usecases/get_all_rooms.dart';
import 'package:grouptalk/features/room/domain/usecases/get_joined_rooms.dart';
import 'package:grouptalk/features/room/domain/usecases/join_room.dart';
import 'package:grouptalk/features/room/presentation/bloc/room_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //* ========================
  //* Firebase
  //* ========================
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

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
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getAuthState: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(authRepository: sl()));

  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(authRepository: sl()),
  );

  sl.registerLazySingleton<LogoutUser>(() => LogoutUser(authRepository: sl()));

  sl.registerLazySingleton<GetAuthState>(
    () => GetAuthState(authRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  //* ========================
  //* Authentication Featur
  //* ========================

  // Bloc
  sl.registerFactory<RoomBloc>(
    () => RoomBloc(
      createRoom: sl(),
      getJoinedRooms: sl(),
      getAllRooms: sl(),
      joinRoom: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<CreateRoom>(() => CreateRoom(repository: sl()));
  sl.registerLazySingleton<GetJoinedRooms>(
    () => GetJoinedRooms(repository: sl()),
  );
  sl.registerLazySingleton<GetAllRooms>(() => GetAllRooms(repository: sl()));
  sl.registerLazySingleton<JoinRoom>(() => JoinRoom(repository: sl()));

  // Repository
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );
}
