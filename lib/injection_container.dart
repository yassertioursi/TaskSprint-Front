import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/network/network_info.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/signup.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/bloc/login_signup_bloc.dart';
import 'package:flutter_application_1/features/home/domain/usecases/get_tasks.dart';
import 'package:flutter_application_1/features/home/domain/usecases/create_task.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_bloc.dart';
import 'package:flutter_application_1/features/home/domain/repositories/tasks_repository.dart';
import 'package:flutter_application_1/features/home/data/repositories/task_repository_impl.dart';
import 'package:flutter_application_1/features/home/data/datasources/tasks_remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(() {
    Dio dio = Dio(BaseOptions(
      baseUrl: "http://localhost:8000/api",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTI4MDE3MDMsImV4cCI6MTc1MjgwNTMwMywibmJmIjoxNzUyODAxNzAzLCJqdGkiOiJuTlZkZXVnUTdvS3Q5NWdhIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.GKGoIAgOXVD2OJkSEkb2D-5rIoZx7OmBTeYzFUVCjxQ'
      },
    ));

    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ));

    return dio;
  });
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteImpl(dio: sl()));
  sl.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(dio: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<TasksRepository>(
    () => TaskRepositoryImpl(
      taskRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));

  // Bloc
  sl.registerFactory(() => LoginSignupBloc(login: sl(), signup: sl()));
  sl.registerFactory(() => TasksBloc(getTasks: sl()));
  sl.registerFactory(() => CreateTaskBloc(createTask: sl()));
}
