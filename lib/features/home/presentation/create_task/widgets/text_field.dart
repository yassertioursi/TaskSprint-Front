import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class UnderlinedTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color? underlineColor;
  final Color? hintTextColor;
  final Color? textColor ; 
  final Color? labelTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final bool enabled;

  const UnderlinedTextField({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.underlineColor,
    this.hintTextColor,
    this.textColor,
  this.labelTextColor,
    this.fontSize,
    this.fontWeight,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onTap,
    this.enabled = true, 
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onTap: onTap,
      cursorHeight: 18.h,
      cursorColor:  textColor ?? AppColors.mainBlack,
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: textColor ?? AppColors.mainBlack,
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
      decoration: InputDecoration(
        counterText: maxLength != null ? null : '',
        labelText: hintText,
        labelStyle: TextStyle(
          color: labelTextColor ?? AppColors.mainBlack,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: hintTextColor ?? AppColors.subGrey,
          fontSize: fontSize ?? 18.sp,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: labelTextColor ?? AppColors.mainYellow,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: _buildBorder(underlineColor ?? AppColors.subGrey),
        enabledBorder: _buildBorder(underlineColor ?? AppColors.subGrey),
        focusedBorder:
            _buildBorder(underlineColor ?? AppColors.mainYellow),
        errorBorder: _buildBorder(AppColors.errorRed),
        focusedErrorBorder: _buildBorder(AppColors.errorRed),
        disabledBorder: _buildBorder(AppColors.subGrey.withOpacity(0.5)),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: prefixIcon != null || suffixIcon != null ? 0 : 4.w,
        ),
        errorStyle: TextStyle(
          color: AppColors.errorRed,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  UnderlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }



  
}
