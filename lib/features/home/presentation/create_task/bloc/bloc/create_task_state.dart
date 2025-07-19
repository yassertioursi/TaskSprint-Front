

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';

@immutable
sealed class CreateTaskState extends Equatable {
  const CreateTaskState();
  
  @override
  List<Object?> get props => [];
}

class CreateTaskInitial extends CreateTaskState {}

class CreatingTask extends CreateTaskState {}

class TaskCreated extends CreateTaskState {
  final TaskEntity task;
  
  const TaskCreated({required this.task});
  
  @override
  List<Object?> get props => [task];
}

class ErrorCreateTaskState extends CreateTaskState {
  final String message;
  
  const ErrorCreateTaskState({required this.message});
  
  @override
  List<Object?> get props => [message];
}