import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_event.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_state.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TodayTaskItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskStatusPage extends StatelessWidget {
  final String status;
  final String categoryName;
  final int taskCount;
  final int totalTasks;

  const TaskStatusPage({
    super.key,
    required this.status,
    required this.categoryName,
    required this.taskCount,
    required this.totalTasks,
  });

  Future<void> _onRefresh(BuildContext context) async {
    context.read<TasksBloc>().add(GetTasksEvent(status: status));
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    // Dispatch event to get tasks by status
    context.read<TasksBloc>().add(GetTasksEvent(status: status));

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                color: AppColors.mainYellow,
                backgroundColor: AppColors.bgBlack,
                child: _buildTaskStatusList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.mainBlack,
        border: Border(
          bottom: BorderSide(
            color: AppColors.subGrey,
            width: 0.2,
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildBackButton(context),
          ),
          Align(
            alignment: Alignment.center,
            child:
                _buildTaskCategoryHeader(categoryName, taskCount, totalTasks),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatusList(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is LoadingTasks) {
          return Center(
              child: CircularProgressIndicator(color: AppColors.mainYellow));
        }
        if (state is TasksAndCountsState && state.tasks != null) {
          if (state.tasks!.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 100.h),
                Center(child: Text("No tasks for this status.")),
              ],
            );
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.tasks!.length,
            itemBuilder: (context, index) {
              final task = state.tasks![index];
              return TodayTaskItem(
                title: task.title,
                project: "Project ${task.projectId}",
              );
            },
          );
        }
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 100.h),
            Center(child: Text("No tasks loaded.")),
          ],
        );
      },
    );
  }

  Widget _buildTaskCategoryHeader(
      String categoryName, int taskCount, int totalTasks) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 45.h,
          width: 45.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: categoryName == 'To Do'
                ? AppColors.toDoColor
                : categoryName == 'In Progress'
                    ? AppColors.inProgressColor
                    : AppColors.doneColor,
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.mainWhite,
              ),
            ),
            Text(
              '$taskCount / $totalTasks',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.subGrey,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: const BoxDecoration(
          color: AppColors.mainYellow,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.mainWhite,
          size: 20.sp,
        ),
      ),
    );
  }
}
