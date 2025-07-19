import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectField extends StatefulWidget {
  final String? hintText;
  final Color? underlineColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onProjectSelected;
  final List<String> projects;

  const ProjectField({
    super.key,
    this.hintText = 'Project',
    this.underlineColor,
    this.textColor,
    this.fontWeight,
    this.controller,
    this.validator,
    this.onProjectSelected,
    this.projects = const ['Work', 'Personal', 'Study', 'Health', 'Shopping'],
  });

  @override
  State<ProjectField> createState() => _ProjectFieldState();
}

class _ProjectFieldState extends State<ProjectField> {
  late final TextEditingController _internalController;
  late final TextEditingController _effectiveController;
  bool _isOpen = false;
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _effectiveController = widget.controller ?? _internalController;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AbsorbPointer(
        child: UnderlinedTextField(
          hintText: widget.hintText,
          controller: _effectiveController,
          validator: widget.validator,
          underlineColor: widget.underlineColor ?? AppColors.mainWhite,
          textColor: widget.textColor ?? AppColors.mainWhite,
          labelTextColor: AppColors.mainYellow,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
          keyboardType: TextInputType.none,
          suffixIcon: Icon(
            _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: widget.textColor ?? AppColors.mainYellow,
            size: 25.sp,
          ),
        ),
      ),
    );
  }

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    setState(() => _isOpen = true);
    _overlay = _createOverlay();
    Overlay.of(context).insert(_overlay!);
  }

  void _close() {
    setState(() => _isOpen = false);
    _overlay?.remove();
    _overlay = null;
  }

  OverlayEntry _createOverlay() {
    final box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: _close, // Close dropdown when tapping outside
        child: Stack(
          children: [
            // Invisible full-screen container to catch taps outside
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            // Dropdown content
            Positioned(
              left: position.dx,
              top: position.dy + box.size.height + 8.h,
              width: box.size.width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 200.h),
                  decoration: BoxDecoration(
                    color: widget.textColor == AppColors.mainBlack
                        ? AppColors.mainWhite
                        : AppColors.bgBlack,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: widget.underlineColor ?? AppColors.mainYellow,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.projects.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: (widget.textColor == AppColors.mainBlack
                              ? AppColors.subGrey
                              : AppColors.mainWhite)
                          .withOpacity(0.2),
                    ),
                    itemBuilder: (_, index) =>
                        _buildItem(widget.projects[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String project) {
    final selected = _effectiveController.text == project;
    final isDarkMode = widget.textColor != AppColors.mainBlack;

    return InkWell(
      onTap: () => _select(project),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected
              ? (widget.underlineColor ?? AppColors.mainYellow).withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            // Project icon
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: _getProjectColor(project),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getProjectIcon(project),
                color: Colors.white,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Project name
            Expanded(
              child: Text(
                project,
                style: TextStyle(
                  color: selected
                      ? (widget.underlineColor ?? AppColors.mainYellow)
                      : (isDarkMode
                          ? AppColors.mainWhite
                          : AppColors.mainBlack),
                  fontSize: 14.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            // Checkmark for selected item
            if (selected)
              Icon(
                Icons.check,
                color: widget.underlineColor ?? AppColors.mainYellow,
                size: 16.sp,
              ),
          ],
        ),
      ),
    );
  }

  Color _getProjectColor(String project) {
    switch (project.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'study':
        return Colors.purple;
      case 'health':
        return Colors.red;
      case 'shopping':
        return Colors.orange;
      case 'travel':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getProjectIcon(String project) {
    switch (project.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'study':
        return Icons.school;
      case 'health':
        return Icons.favorite;
      case 'shopping':
        return Icons.shopping_cart;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.folder;
    }
  }

  void _select(String project) {
    setState(() => _effectiveController.text = project);
    widget.onProjectSelected?.call(project);
    _close();
  }

  @override
  void dispose() {
    _close();
    // Only dispose internal controller if we created it
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }
}
