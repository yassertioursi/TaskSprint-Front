import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskCategory extends StatelessWidget {
  final String categoryName;
  final int taskCount;
  final int totalTasks;
  const TaskCategory(
      {super.key,
      required this.categoryName,
      required this.taskCount,
      required this.totalTasks});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 30.h,
              width: 30.w,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
        IconButton(
          onPressed: () {},
          icon: FaIcon(
            FontAwesomeIcons.angleRight,
            color: AppColors.mainYellow , 
            size: 20.sp,
          ),
        ), 
      ],
    );
  }
}
