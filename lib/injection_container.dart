import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/config/app_config.dart';
import 'package:flutter_application_1/core/network/network_info.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/signup.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/bloc/login_signup_bloc.dart';
import 'package:flutter_application_1/features/home/data/datasources/projects_remote_data_source.dart';
import 'package:flutter_application_1/features/home/data/repositories/project_repository_impl.dart';
import 'package:flutter_application_1/features/home/domain/repositories/projects_repository.dart';
import 'package:flutter_application_1/features/home/domain/usecases/projects/create_project.dart';
import 'package:flutter_application_1/features/home/domain/usecases/projects/get_projects.dart';
import 'package:flutter_application_1/features/home/domain/usecases/tasks/get_task_counts.dart';
import 'package:flutter_application_1/features/home/domain/usecases/tasks/get_tasks.dart';
import 'package:flutter_application_1/features/home/domain/usecases/tasks/create_task.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/bloc/create_project_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/projects/projects_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_bloc.dart';
import 'package:flutter_application_1/features/home/domain/repositories/tasks_repository.dart';
import 'package:flutter_application_1/features/home/data/repositories/task_repository_impl.dart';
import 'package:flutter_application_1/features/home/data/datasources/tasks_remote_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(() {
    Dio dio = Dio(BaseOptions(
      validateStatus: (status) => status != null && status < 500,
      baseUrl: "http://localhost:8000/api",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add auth interceptor - automatically adds token to requests
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Skip auth for login/register endpoints
        if (!options.path.contains('/auth/login') && 
            !options.path.contains('/auth/register')) {
          options.headers['Authorization'] = AppConfig.authorizationHeader;
        }
        handler.next(options);
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
  
  sl.registerLazySingleton<ProjectRemoteDataSource>(
      () => ProjectRemoteDataSourceImpl(dio: sl()));

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
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectRepositoryImpl(
      projectRemoteDataSource: sl(), 
      networkInfo: sl(),
    ),
  );
 
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
   sl.registerLazySingleton(() => GetTaskCountsUseCase(sl()));
 sl.registerLazySingleton(() => CreateTaskUseCase(sl()));  
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
   sl.registerLazySingleton(() => CreateProjectUseCase(sl()));

  // Bloc
  sl.registerFactory(() => LoginSignupBloc(login: sl(), signup: sl()));
  sl.registerFactory(() => TasksBloc(getTasks: sl()  , getTaskCounts: sl()));
  sl.registerFactory(() => CreateTaskBloc(createTask: sl()));
  sl.registerFactory(() => ProjectsBloc(getProjects: sl()));
  sl.registerFactory(() => CreateProjectBloc(createProject: sl()));
}
