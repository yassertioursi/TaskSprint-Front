import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/utils/forms_data.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_signup_button.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_event.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_state.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/date_field.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/project_field.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/text_field.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/widgets/time_field.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late final CreateTaskFormData _formData;

  @override
  void initState() {
    super.initState();
    _formData = CreateTaskFormData();
  }

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainYellow,
      body: BlocListener<CreateTaskBloc, CreateTaskState>(
        listener: (context, state) {
          if (state is TaskCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ErrorCreateTaskState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formData.formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  _buildCreateHeader(context),
                  SizedBox(height: 20.h),
                  _buildTopFields(),
                ],
              ),
            ),
            Expanded(child: _buildBottomContainer()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFields() {
    return Column(
      children: [
        UnderlinedTextField(
          hintText: 'Title',
          controller: _formData.titleController,
          keyboardType: TextInputType.text,
          underlineColor: AppColors.mainBlack , 
          textColor: AppColors.mainBlack,
          labelTextColor: AppColors.mainWhite,
          fontWeight: FontWeight.w500,
          validator: _formData.validateTitle,
        ),
        SizedBox(height: 20.h),
        DateField(
          hintText: 'Date',
          underlineColor: AppColors.mainBlack,
          textColor: AppColors.mainBlack,
          fontWeight: FontWeight.w500,
          controller: _formData.dateController,
          validator: _formData.validateDate,
          onDateSelected: (date) {
            _formData.setDate(date);
          },
        ),
      ],
    );
  }

  Widget _buildBottomContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.mainBlack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: _buildBottomFields(),
    );
  }

  Widget _buildBottomFields() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTimeFields(),
          SizedBox(height: 40.h),
          UnderlinedTextField(
            hintText: 'Description',
            controller: _formData.descriptionController,
            keyboardType: TextInputType.multiline,
            underlineColor: AppColors.mainYellow,
            textColor: AppColors.mainWhite,
            labelTextColor:  AppColors.mainYellow ,
            fontWeight: FontWeight.w500,
            validator: _formData.validateDescription,
          ),
          SizedBox(height: 40.h),
          ProjectField(
            hintText: 'Project',
            underlineColor: AppColors.mainYellow,
            textColor: AppColors.mainWhite,
            fontWeight: FontWeight.w500,
            controller: _formData.projectController,
            validator: _formData.validateProject,
            projects: const ['Work', 'Personal', 'Study', 'Health', 'Shopping', 'Travel'],
            onProjectSelected: (project) {
              _formData.setProject(project);
            },
          ),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: BlocBuilder<CreateTaskBloc, CreateTaskState>(
              builder: (context, state) {
                return LoginSignupButton(
                  buttonText: state is CreatingTask ? "Creating..." : "Create Task",
                  onPressed: state is CreatingTask ? null : _onCreateTask,
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTimeFields() {
    return Row(
      children: [
        Expanded(
          child: TimeField(
            hintText: 'Start Time',
            controller: _formData.startTimeController,
            underlineColor: AppColors.mainYellow,
            textColor: AppColors.mainWhite,
            cursorColor: AppColors.mainWhite,
            fontWeight: FontWeight.w500,
            validator: _formData.validateStartTime,
            onTimeSelected: (time) {
              _formData.setStartTime(time);
            },
          ),
        ),
        SizedBox(width: 40.w),
        Expanded(
          child: TimeField(
            hintText: 'End Time',
            controller: _formData.endTimeController,
            underlineColor: AppColors.mainYellow,
            textColor: AppColors.mainWhite,
            cursorColor: AppColors.mainWhite,
            fontWeight: FontWeight.w500,
            validator: _formData.validateEndTime,
            onTimeSelected: (time) {
              _formData.setEndTime(time);
            },
          ),
        ),
      ],
    );
  }

  void _onCreateTask() {
    if (!_formData.isFormValid()) {
      return;
    }

    // Create TaskEntity
    final taskEntity = TaskEntity(
      id: 0,
      title: _formData.titleController.text.trim(),
      description: _formData.descriptionController.text.trim(),
      startTimestamp: DateTime(
        _formData.selectedDate!.year,
        _formData.selectedDate!.month,
        _formData.selectedDate!.day,
        _formData.startTime!.hour,
        _formData.startTime!.minute,
      ),
      endTimestamp: DateTime(
        _formData.selectedDate!.year,
        _formData.selectedDate!.month,
        _formData.selectedDate!.day,
        _formData.endTime!.hour,
        _formData.endTime!.minute,
      ),
      status: TaskEntityStatus.toDo,
      projectId: _getProjectId(_formData.selectedProject!),
      userId: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Submit to BLoC
    context.read<CreateTaskBloc>().add(
      CreateTaskSubmitEvent(task: taskEntity),
    );
  }

  int _getProjectId(String projectName) {
    switch (projectName.toLowerCase()) {
      case 'work': return 1;
      case 'personal': return 2;
      case 'study': return 3;
      case 'health': return 4;
      case 'shopping': return 5;
      case 'travel': return 6;
      default: return 1;
    }
  }

  Widget _buildCreateHeader(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _buildBackButton(context),
          ),
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Create New Task',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.arrow_back,
          size: 20.sp,
          color: AppColors.mainYellow,
        ),
      ),
    );
  }
}