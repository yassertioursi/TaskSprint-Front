import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectItem extends StatelessWidget {
  
  final String projectTitle;
  final double progress;
  final String date;

  const ProjectItem({
    super.key,
    required this.projectTitle,
    required this.progress,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.mainYellow,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateWidget(),
          SizedBox(height: 20.h),
          _buildProjectInfoWidget(),
          SizedBox(height: 20.h),
          _buildProgressWidget(),
        ],
      ),
    );
  }

  Widget _buildDateWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          date,
          style: TextStyle(
            color: AppColors.mainBlack,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
        Text(
          projectTitle,
          style: TextStyle(
            color: AppColors.mainWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress",
              style: TextStyle(
                color: AppColors.mainWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                color: AppColors.mainWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.mainWhite.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }
}
