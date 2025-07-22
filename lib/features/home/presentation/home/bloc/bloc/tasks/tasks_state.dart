import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/entities/task_counts.dart';

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

class LoadingTaskCounts extends TasksState {}

class TaskCountsLoaded extends TasksState {
  final TaskCounts taskCounts;

  const TaskCountsLoaded({required this.taskCounts});

  @override
  List<Object?> get props => [taskCounts];
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

class TasksAndCountsState extends TasksState {
  final List<TaskEntity>? tasks;
  final TaskCounts? taskCounts;
  final bool isLoadingTasks;
  final bool isLoadingCounts;
  
  const TasksAndCountsState({
    this.tasks,
    this.taskCounts,
    this.isLoadingTasks = false,
    this.isLoadingCounts = false,
  });
  
  @override
  List<Object?> get props => [tasks, taskCounts, isLoadingTasks, isLoadingCounts];
  
  TasksAndCountsState copyWith({
    List<TaskEntity>? tasks,
    TaskCounts? taskCounts,
    bool? isLoadingTasks,
    bool? isLoadingCounts,
  }) {
    return TasksAndCountsState(
      tasks: tasks ?? this.tasks,
      taskCounts: taskCounts ?? this.taskCounts,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      isLoadingCounts: isLoadingCounts ?? this.isLoadingCounts,
    );
  }
}
