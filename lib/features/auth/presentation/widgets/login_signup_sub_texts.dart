import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSignupSubTexts extends StatelessWidget {
  final String question;
  final String routerTextButton;
  final VoidCallback onPressed;

  const LoginSignupSubTexts({
    super.key,
    required this.question,
    required this.routerTextButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: TextStyle(color: AppColors.subGrey, fontSize: 18.sp),
        ),
        InkWell(
          onTap: onPressed,
          child: Text(
            routerTextButton,
            style: TextStyle(
              color: AppColors.mainYellow,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
