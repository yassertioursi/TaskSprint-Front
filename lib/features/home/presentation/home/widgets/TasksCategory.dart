import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TaskCategory.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TaskCategory(categoryName: "To Do", taskCount: 5, totalTasks: 7),
          SizedBox(height: 20.h),
          TaskCategory(
              categoryName: "In Progress", taskCount: 5, totalTasks: 7),
          SizedBox(height: 20.h),
          TaskCategory(categoryName: "Done", taskCount: 5, totalTasks: 7),
        ],
      ),
    );
  }
}
