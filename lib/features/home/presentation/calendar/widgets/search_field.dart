import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;

  const SearchField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorHeight:17,
      validator: (value) {
        return null;
      
      },
      cursorColor: Colors.black,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        counterText: '',
        errorStyle: const TextStyle(color: AppColors.errorRed),
        contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.subGrey,
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
        hintText: "Search tasks...",
        hintStyle: TextStyle(
          color: AppColors.subGrey,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
        fillColor: AppColors.mainWhite,
        filled: true,
      ),
    ); 
  }
}
