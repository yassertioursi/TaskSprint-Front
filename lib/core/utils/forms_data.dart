import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskFormData {
  // Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Selected values
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedProject;

  // Dispose all controllers
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    projectController.dispose();
  }

  // Validators
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 5) {
      return 'Description must be at least 5 characters';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (selectedDate == null) {
      return 'Please select a date';
    }
    if (selectedDate!.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Date cannot be in the past';
    }
    return null;
  }

  String? validateStartTime(String? value) {
    if (startTime == null) {
      return 'Please select start time';
    }
    return null;
  }

  String? validateEndTime(String? value) {
    if (endTime == null) {
      return 'Please select end time';
    }
    
    if (startTime != null && endTime != null) {
      final startDateTime = DateTime(
        selectedDate?.year ?? DateTime.now().year,
        selectedDate?.month ?? DateTime.now().month,
        selectedDate?.day ?? DateTime.now().day,
        startTime!.hour,
        startTime!.minute,
      );
      
      final endDateTime = DateTime(
        selectedDate?.year ?? DateTime.now().year,
        selectedDate?.month ?? DateTime.now().month,
        selectedDate?.day ?? DateTime.now().day,
        endTime!.hour,
        endTime!.minute,
      );
      
      if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
        return 'End time must be after start time';
      }
    }
    
    return null;
  }

  String? validateProject(String? value) {
    if (selectedProject == null || selectedProject!.isEmpty) {
      return 'Please select a project';
    }
    return null;
  }

  // Helper methods
  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = DateFormat('EEEE, d MMM yyyy').format(date);
  }

  void setStartTime(TimeOfDay time) {
    startTime = time;
    startTimeController.text = _formatTimeOfDay(time);
  }

  void setEndTime(TimeOfDay time) {
    endTime = time;
    endTimeController.text = _formatTimeOfDay(time);
  }

  void setProject(String project) {
    selectedProject = project;
    projectController.text = project;
  }

  // Helper method to format time
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Validation check
  bool isFormValid() {
    return formKey.currentState?.validate() ?? false;
  }

  // Clear all form data
  void clear() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    projectController.clear();
    
    selectedDate = null;
    startTime = null;
    endTime = null;
    selectedProject = null;
  }

  // Check if form has data
  bool get hasData {
    return titleController.text.isNotEmpty ||
           descriptionController.text.isNotEmpty ||
           selectedDate != null ||
           startTime != null ||
           endTime != null ||
           selectedProject != null;
  }
}