import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeField extends StatefulWidget {
  final String? hintText;
  final Color? underlineColor;
  final Color? textColor;
  final Color? cursorColor;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(TimeOfDay)? onTimeSelected;

  const TimeField({
    super.key,
    this.hintText = 'Time',
    this.underlineColor,
    this.textColor,
    this.cursorColor,
    this.fontWeight,
    this.controller,
    this.validator,
    this.onTimeSelected,
  });

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  late final TextEditingController _internalController;
  late final TextEditingController _effectiveController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _effectiveController = widget.controller ?? _internalController;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectTime,
      child: AbsorbPointer(
        child: UnderlinedTextField(
          hintText: widget.hintText,
         

       hintTextColor: AppColors.mainYellow,
          controller: _effectiveController,
          validator: widget.validator,
          underlineColor: widget.underlineColor ?? AppColors.mainWhite,
          textColor: widget.textColor ?? AppColors.mainWhite,
          labelTextColor: AppColors.mainYellow,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
          keyboardType: TextInputType.none,
          suffixIcon: Icon(
            Icons.access_time,
            color: widget.textColor ?? AppColors.mainWhite,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _getCurrentTime(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: widget.underlineColor ?? AppColors.mainYellow, // Header background
              onPrimary: AppColors.mainWhite, // Header text
              surface: AppColors.bgBlack, // Dialog background
              onSurface: AppColors.mainWhite, // Dialog text
              background: AppColors.bgBlack, // Background
              onBackground: AppColors.mainWhite, // Background text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: widget.underlineColor ?? AppColors.mainYellow,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.bgBlack,
              hourMinuteTextColor: AppColors.mainWhite,
              hourMinuteColor: AppColors.subGrey.withOpacity(0.2),
              dayPeriodTextColor: AppColors.mainWhite,
              dayPeriodColor: AppColors.subGrey.withOpacity(0.2),
              dialHandColor: widget.underlineColor ?? AppColors.mainYellow,
              dialBackgroundColor: AppColors.subGrey.withOpacity(0.2),
              dialTextColor: AppColors.mainWhite,
              entryModeIconColor: AppColors.mainWhite,
              helpTextStyle: TextStyle(
                color: AppColors.mainWhite,
                fontSize: 14.sp,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _effectiveController.text = _formatTimeOfDay(picked);
      });
      widget.onTimeSelected?.call(picked);
    }
  }

  TimeOfDay _getCurrentTime() {
    if (_effectiveController.text.isNotEmpty) {
      try {
        final parts = _effectiveController.text.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          return TimeOfDay(hour: hour, minute: minute);
        }
      } catch (e) {
        // If parsing fails, return current time
      }
    }
    return TimeOfDay.now();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    // Only dispose internal controller if we created it
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }
}