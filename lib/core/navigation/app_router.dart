import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/navigation/app_routes.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_application_1/features/home/presentation/calendar/pages/calendar_page.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/pages/create_task.dart';
import 'package:flutter_application_1/features/home/presentation/home/pages/home_page.dart';
import 'package:flutter_application_1/features/home/presentation/home/pages/main_navigation_page.dart';
import 'package:flutter_application_1/features/home/presentation/task_status/pages/task_status_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _fadeRoute(const LoginPage());
      case AppRoutes.signup:
        return _fadeRoute(const SignupPage());
      case AppRoutes.home:
        return _fadeRoute(const HomePage());
      case AppRoutes.calendar:
        return _fadeRoute(const CalendarPage());
      case AppRoutes.mainNavigation:
        return _fadeRoute(const MainNavigationPage());
      case AppRoutes.createTask:
        return _fadeRoute(const CreateTask());
      case AppRoutes.tasksPerStatus:
        final args = settings.arguments as Map<String, dynamic>?;

        return _fadeRoute(
          TaskStatusPage(
            status: args?['status'] ?? 'todo',
            categoryName: args?['categoryName'] ?? 'To Do',
            taskCount: args?['taskCount'] ?? 0,
            totalTasks: args?['totalTasks'] ?? 0,
          ),
        );

      default:
        return _fadeRoute(const LoginPage());
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
