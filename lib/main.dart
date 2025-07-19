import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/navigation/app_router.dart';
import 'package:flutter_application_1/core/navigation/app_routes.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/bloc/login_signup_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_bloc.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_application_1/features/calendar/presentation/pages/calendar_page.dart';
import 'package:flutter_application_1/features/home/presentation/home/pages/home_page.dart';
import 'package:flutter_application_1/features/home/presentation/home/pages/main_navigation_page.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/pages/create_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              try {
                return di.sl<LoginSignupBloc>();
              } catch (e) {
                print('Error initializing LoginSignupBloc: $e');
                rethrow;
              }
            },
          ),
          BlocProvider(
            create: (context) {
              try {
                return di.sl<TasksBloc>();
              } catch (e) {
                print('Error initializing TasksBloc: $e');
                rethrow;
              }
            },
          ),
           BlocProvider(
            create: (context) {
              try {
                return di.sl<CreateTaskBloc>();
              } catch (e) {
                print('Error initializing TasksBloc: $e');
                rethrow;
              }
            },
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoutes.createTask,
          onGenerateRoute: AppRouter.generateRoute,
          debugShowCheckedModeBanner: false,
          home: const SafeArea(child: CreateTask()),
        ),
      ),
    );
  }
}
