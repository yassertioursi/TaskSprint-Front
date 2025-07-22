import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/utils/forms_data.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/date_field.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/text_field.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_signup_button.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/bloc/create_project_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/bloc/create_project_event.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/bloc/create_project_state.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProjectBottomSheet extends StatefulWidget {
  const CreateProjectBottomSheet({super.key});

  @override
  State<CreateProjectBottomSheet> createState() =>
      _CreateProjectBottomSheetState();
}

class _CreateProjectBottomSheetState extends State<CreateProjectBottomSheet> {
  late final CreateProjectFormData _formData;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _formData = CreateProjectFormData();
  }

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProjectBloc, CreateProjectState>(
      listener: (context, state) {
        if (state is ProjectCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ErrorCreateProjectState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.bgBlack,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                _buildHandleBar(),
                // Header
                _buildHeader(),
                // Form content
                Expanded(
                  child: _buildForm(scrollController),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      width: 50.w,
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.subGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Create New Project',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.mainWhite,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: AppColors.subGrey,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(ScrollController scrollController) {
    return Form(
      key: _formData.formKey,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // Project Title
            UnderlinedTextField(
              hintText: 'Project Title',
              controller: _formData.titleController,
              underlineColor: AppColors.mainYellow,
              textColor: AppColors.mainWhite,
              labelTextColor: AppColors.mainYellow,
              fontWeight: FontWeight.w500,
              validator: _formData.validateTitle,
            ),

            SizedBox(height: 30.h),

            // Project Description
            UnderlinedTextField(
              hintText: 'Description',
              controller: _formData.descriptionController,
              keyboardType: TextInputType.multiline,
              underlineColor: AppColors.mainYellow,
              textColor: AppColors.mainWhite,
              labelTextColor: AppColors.mainYellow,
              fontWeight: FontWeight.w500,
              maxLines: 3,
              validator: _formData.validateDescription,
            ),

            SizedBox(height: 30.h),

            // End Date Field - styled like other fields
            DateField(
              hintText: 'End Date',
              controller: _formData.endDateController,
              underlineColor: AppColors.mainYellow,
              textColor: AppColors.mainWhite,
              fontWeight: FontWeight.w500,
              validator: _formData.validateEndDate,
              onDateSelected: (date) {
                _formData.setEndDate(date);
                _endDate = date;
              },
            ),

            SizedBox(height: 50.h),

            // Create Button with BLoC Builder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocBuilder<CreateProjectBloc, CreateProjectState>(
                builder: (context, state) {
                  return LoginSignupButton(
                    buttonText: state is CreatingProject
                        ? "Creating..."
                        : "Create Project",
                    onPressed:
                        state is CreatingProject ? null : _onCreateProject,
                  );
                },
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  void _onCreateProject() {
    if (_formData.isFormValid()) {
      // Only check for end date since we removed start date
      if (_formData.endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an end date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create ProjectEntity
      final projectEntity = ProjectEntity(
        id: 0, // Will be set by the server
        title: _formData.titleController.text.trim(),
        description: _formData.descriptionController.text.trim(),
 // Use current date as start date
        endTimestamp: _formData.endDate!,
        userId: 0, // Will be set by the server based on auth
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Submit to BLoC
      context.read<CreateProjectBloc>().add(
            CreateProjectSubmitEvent(project: projectEntity),
          );
    }
  }
}

// Extension method to show the bottom sheet with BLoC provider
extension CreateProjectBottomSheetExtension on BuildContext {
  void showCreateProjectBottomSheet() {
    showModalBottomSheet(
      context: this,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => BlocProvider(
        create: (context) => CreateProjectBloc(
          createProject: context.read(), // Get from dependency injection
        ),
        child: const CreateProjectBottomSheet(),
      ),
    );
  }
}
