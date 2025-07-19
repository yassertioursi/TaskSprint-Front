import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TaskStatus { toDo, inProgress, done }

class TodayTaskItem extends StatelessWidget {
  final String title;
  final String project;
  final TaskStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onOptionsTap;
  final VoidCallback? onStatusTap;

  const TodayTaskItem({
    super.key,
    required this.title,
    required this.project,
    this.status = TaskStatus.toDo,
    this.onTap,
    this.onOptionsTap,
    this.onStatusTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        child: Stack(
          children: [
            _buildMainContainer(),
            _buildIconContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer() {
    return Container(
      height: 80.h, // Increased height to accommodate all content
      padding: EdgeInsets.fromLTRB(80.w, 12.h, 12.w, 12.h), // Adjusted padding
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(16.r), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildTaskContent()),
          _buildOptionsButton(),
        ],
      ),
    );
  }

  Widget _buildTaskContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: AppColors.mainBlack,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3.h),
        Text(
          project,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.mainYellow,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          _getStatusText(),
          style: TextStyle(
            fontSize: 9.sp,
            color: _getStatusColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsButton() {
    return Container(
      width: 24.w,
      height: 24.h,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          color: AppColors.mainBlack,
          size: 14.sp,
        ),
        onPressed: onOptionsTap,
      ),
    );
  }

  Widget _buildIconContainer() {
    return Positioned(
      left: 0,
      // Match the main container's top margin
      child: Container(
        height: 80.h, // Same height as main container
        width: 70.w,
        decoration: BoxDecoration(
          color: _getIconBackgroundColor(),
          borderRadius: BorderRadius.only(

            topLeft: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: _getIconBackgroundColor().withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FaIcon(
            _getStatusIcon(),
            color: AppColors.mainWhite,
            size: 28.sp,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case TaskStatus.toDo:
        return AppColors.toDoColor;
      case TaskStatus.inProgress:
        return AppColors.inProgressColor;
      case TaskStatus.done:
        return AppColors.doneColor;
    }
  }

  Color _getIconBackgroundColor() {
    switch (status) {
      case TaskStatus.toDo:
        return AppColors.toDoColor;
      case TaskStatus.inProgress:
        return AppColors.inProgressColor;
      case TaskStatus.done:
        return AppColors.doneColor;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case TaskStatus.toDo:
        return FontAwesomeIcons.clock;
      case TaskStatus.inProgress:
        return FontAwesomeIcons.spinner;
      case TaskStatus.done:
        return FontAwesomeIcons.check;
    }
  }

  String _getStatusText() {
    switch (status) {
      case TaskStatus.toDo:
        return "To Do";
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.done:
        return "Done";
    }
  }
}
