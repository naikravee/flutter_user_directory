import 'package:flutter_user_directory/core/network/http_client.dart';
import 'package:flutter_user_directory/features/users/presentation/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';
import '../features/users/data/datasource/user_local_datasource.dart';
import '../features/users/data/repository/user_repository_impl.dart';

GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Hive Box
  sl.registerLazySingleton<Box>(() => Hive.box(AppConstants.usersBox));

  // Datasources

  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(sl()),
  );

  // Repository

  sl.registerLazySingleton<UserRepositoryImpl>(
    () => UserRepositoryImpl(remoteDatasource: sl(), localDatasource: sl()),
  );

  // Bloc
  sl.registerFactory<UserBloc>(() => UserBloc(repository: sl()));
}
