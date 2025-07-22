import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/text_field.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectField extends StatefulWidget {
  final String? hintText;
  final Color? underlineColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(ProjectEntity)? onProjectSelected; // Changed to ProjectEntity
  final List<ProjectEntity> projects; // Changed to ProjectEntity list
  final bool isLoading;

  const ProjectField({
    super.key,
    this.hintText = 'Project',
    this.underlineColor,
    this.textColor,
    this.fontWeight,
    this.controller,
    this.validator,
    this.onProjectSelected,
    this.projects = const [], // Empty by default
    this.isLoading = false,

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
      onTap: widget.isLoading ? null : _toggle,
      child: AbsorbPointer(
        child: UnderlinedTextField(
          hintText: widget.isLoading ? 'Loading projects...' : widget.hintText,
          controller: _effectiveController,
          validator: widget.validator,
          underlineColor: widget.underlineColor ?? AppColors.mainWhite,
          textColor: widget.textColor ?? AppColors.mainWhite,
          labelTextColor: AppColors.mainYellow,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
          keyboardType: TextInputType.none,
          suffixIcon:  Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: widget.underlineColor ?? AppColors.mainYellow,
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
        onTap: _close,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
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
                  child: widget.projects.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
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

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Text(
        'No projects available',
        style: TextStyle(
          color: AppColors.subGrey,
          fontSize: 14.sp,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildItem(ProjectEntity project) {
    final selected = _effectiveController.text == project.title;
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
                color: AppColors.mainYellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder,
                color: Colors.white,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Project name
            Expanded(
              child: Text(
                project.title,
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

  void _select(ProjectEntity project) {
    setState(() => _effectiveController.text = project.title);
    widget.onProjectSelected?.call(project);
    _close();
  }

  @override
  void dispose() {
    _close();
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }
}
