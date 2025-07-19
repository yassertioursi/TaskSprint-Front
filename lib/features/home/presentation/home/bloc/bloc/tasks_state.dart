
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';

@immutable
sealed class TasksState extends Equatable {
  const TasksState();
  
  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class LoadingTasks extends TasksState {}

class TasksLoaded extends TasksState {
  final List<TaskEntity> tasks;
  
  const TasksLoaded({required this.tasks});
  
  @override
  List<Object?> get props => [tasks];
}

class ErrorTasksState extends TasksState {
  final String message;
  
  const ErrorTasksState({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class MessageTasksState extends TasksState {
  final String message;
  
  const MessageTasksState({required this.message});
  
  @override
  List<Object?> get props => [message];
}