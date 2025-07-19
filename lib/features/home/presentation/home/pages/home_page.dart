import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_event.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_state.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/cubit/home_tab_cubit.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/ProjectItem.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TasksCategory.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TodayTaskItem.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeTabCubit()),
        // TasksBloc should be provided at a higher level (like in main.dart or app.dart)
        // For now, we'll get it from the existing context
      ],
      child: Scaffold(
        backgroundColor: AppColors.bgBlack,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildProfilePicture(),
                      _buildWelcomeText(),
                    ],
                  ),
                  _buildNotification(),
                ],
              ),
              SizedBox(height: 30.h),
              _buildTabButtons(),
              SizedBox(height: 30.h),
              _buildTabContent(),
              SizedBox(height: 30.h),
              _buildTodayTasks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotification() {
    return IconButton(
      onPressed: () {},
      icon: FaIcon(
        FontAwesomeIcons.solidBell,
        color: AppColors.mainYellow,
        size: 28.sp,
      ),
    );
  }

  Widget _buildTabButtons() {
    return BlocBuilder<HomeTabCubit, HomeTab>(
      builder: (context, selectedTab) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTabButton(
              context,
              'My Tasks',
              HomeTab.myTasks,
              selectedTab == HomeTab.myTasks,
            ),
            SizedBox(width: 15.w),
            _buildTabButton(
              context,
              'My Projects',
              HomeTab.myProjects,
              selectedTab == HomeTab.myProjects,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabButton(
      BuildContext context, String title, HomeTab tab, bool isSelected) {
    return InkWell(
      onTap: () => context.read<HomeTabCubit>().selectTab(tab),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainYellow : AppColors.subYellow,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelected ? AppColors.mainWhite : AppColors.mainYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return BlocBuilder<HomeTabCubit, HomeTab>(
      builder: (context, selectedTab) {
        switch (selectedTab) {
          case HomeTab.myTasks:
            return const TasksCategory();
          case HomeTab.myProjects:
            return const ProjectItem(
              projectTitle: 'Project A',
              progress: 0.5,
              date: 'Nov 30, 2023',
            );
        }
      },
    );
  }

  Widget _buildTodayTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Tasks",
              style: TextStyle(
                color: AppColors.mainYellow,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                // Refresh today's tasks
                context.read<TasksBloc>().add(const GetTasksEvent());
              },
              icon: Icon(
                Icons.refresh,
                color: AppColors.mainYellow,
                size: 20.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        BlocConsumer<TasksBloc, TasksState>(
          listener: (context, state) {
            // Add initial event when widget is first built
            if (state is TasksInitial) {
              context.read<TasksBloc>().add(const GetTasksEvent());
            }
          },
          builder: (context, state) {
            if (state is LoadingTasks) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CircularProgressIndicator(
                    color: AppColors.mainYellow,
                  ),
                ),
              );
            } else if (state is TasksLoaded) {
              if (state.tasks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Text(
                      "No tasks for today!",
                      style: TextStyle(
                        color: AppColors.subGrey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: state.tasks.map((task) {
                  return TodayTaskItem(
                    title: task.title,
                    project: "Project ${task.projectId}",
                    status: _mapTaskStatus(task.status),
                    onTap: () => _onTaskTapped(task),
                    onStatusTap: () => _onStatusTapped(task),
                    onOptionsTap: () => _onOptionsTapped(task),
                  );
                }).toList(),
              );
            } else if (state is ErrorTasksState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Column(
                    children: [
                      Text(
                        "Error: ${state.message}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TasksBloc>().add(const GetTasksEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainYellow,
                        ),
                        child: Text(
                          "Retry",
                          style: TextStyle(
                            color: AppColors.mainWhite,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // TasksInitial state - this will trigger the listener above
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Text(
                  "Loading tasks...",
                  style: TextStyle(
                    color: AppColors.subGrey,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onTaskTapped(TaskEntity task) {
    print("Task tapped: ${task.title}");
    // Navigate to task details or show task details
  }

  void _onStatusTapped(TaskEntity task) {
    print("Status tapped for task: ${task.title}");
    // Show status change options or update status
  }

  void _onOptionsTapped(TaskEntity task) {
    print("Options tapped for task: ${task.title}");
    // Show options menu (edit, delete, etc.)
  }

  // Map TaskStatus from domain entity to widget TaskStatus
  TaskStatus _mapTaskStatus(TaskEntityStatus domainStatus) {
    switch (domainStatus) {
      case TaskEntityStatus.toDo:
        return TaskStatus.toDo;
      case TaskEntityStatus.inProgress:
        return TaskStatus.inProgress;
      case TaskEntityStatus.done:
        return TaskStatus.done;
      default:
        return TaskStatus.toDo;
    }
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 25.r,
      child: CircleAvatar(
        radius: 20.r,
        backgroundImage: const AssetImage('core/images/logo.png'),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          int taskCount = 0;
          if (state is TasksLoaded) {
            taskCount = state.tasks.length;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: AppColors.mainWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const TextSpan(text: 'Hello! '),
                    TextSpan(
                      text: 'Yasser',
                      style: TextStyle(
                        color: AppColors.mainYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.subGrey,
                  ),
                  children: [
                    const TextSpan(text: 'You have '),
                    TextSpan(
                      text: "$taskCount tasks ",
                      style: TextStyle(
                        color: AppColors.mainYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: 'today!'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
