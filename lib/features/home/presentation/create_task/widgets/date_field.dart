import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateField extends StatefulWidget {
  final String? hintText;
  final Color? underlineColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(DateTime)? onDateSelected;

  const DateField({
    super.key,
    this.hintText = 'Date',
    this.underlineColor,
    this.textColor,
    this.fontWeight,
    this.controller,
    this.validator,
    this.onDateSelected,
  });

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
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
      onTap: _selectDate,
      child: AbsorbPointer(
        child: UnderlinedTextField(
          hintText: widget.hintText,
          suffixIcon: Icon(
            Icons.calendar_today,
            color: widget.textColor ?? AppColors.mainBlack,
            size: 20.sp,
          ),
          controller: _effectiveController,
          underlineColor: widget.underlineColor ?? AppColors.mainBlack,
          textColor: widget.textColor ?? AppColors.mainBlack,
          labelTextColor: AppColors.mainWhite ,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
          validator: widget.validator,
          keyboardType: TextInputType.none,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.mainYellow, // Header color
              onPrimary: AppColors.mainWhite, // Text on header
              surface: AppColors.bgBlack, // Dialog background
              onSurface: AppColors.mainWhite, // Text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mainYellow, // Button text color
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: AppColors.mainWhite), // Input text color
              bodyMedium: TextStyle(color: AppColors.mainWhite), // Input text color
              labelLarge: TextStyle(color: AppColors.mainWhite), // Button text color
              headlineMedium: TextStyle(color: AppColors.mainWhite), // Month/year header
              titleMedium: TextStyle(color: AppColors.mainWhite), // Day labels
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _effectiveController.text = _formatDate(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  String _formatDate(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
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
