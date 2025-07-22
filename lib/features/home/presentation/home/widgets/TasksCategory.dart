import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TaskCategory.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksCategory extends StatelessWidget {
  const TasksCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.mainBlack,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          int totalTasks = 0;
          int toDoCount = 0;
          int inProgressCount = 0;
          int doneCount = 0;

          if (state is TasksAndCountsState && state.taskCounts != null) {
            totalTasks = state.taskCounts!.total;
            toDoCount = state.taskCounts!.toDo;
            inProgressCount = state.taskCounts!.inProgress;
            doneCount = state.taskCounts!.done;
          } else if (state is TaskCountsLoaded) {
            totalTasks = state.taskCounts.total;
            toDoCount = state.taskCounts.toDo;
            inProgressCount = state.taskCounts.inProgress;
            doneCount = state.taskCounts.done;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TaskCategory(
                categoryName: "To Do", 
                taskCount: toDoCount, 
                totalTasks: totalTasks
              ),
              SizedBox(height: 20.h),
              TaskCategory(
                categoryName: "In Progress", 
                taskCount: inProgressCount, 
                totalTasks: totalTasks
              ),
              SizedBox(height: 20.h),
              TaskCategory(
                categoryName: "Done", 
                taskCount: doneCount, 
                totalTasks: totalTasks
              ),
            ],
          );
        },
      ),
    );
  }
}
