import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSignupButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isLoading;

  const LoginSignupButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: isLoading ? AppColors.subGrey : AppColors.mainYellow,
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(40),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.mainWhite,
                  ),
                )
              : Text(
                  buttonText,
                  style: TextStyle(
                    color: AppColors.mainWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
