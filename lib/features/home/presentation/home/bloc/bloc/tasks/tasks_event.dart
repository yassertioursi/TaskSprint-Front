import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class TasksEvent extends Equatable {
  const TasksEvent();
}

class GetTasksEvent extends TasksEvent {
  final DateTime? date;
  final String? status;

  const GetTasksEvent({this.date, this.status});

  @override
  List<Object?> get props => [date ,status];
}

class GetTaskCountsEvent extends TasksEvent {
  const GetTaskCountsEvent();

  @override
  List<Object?> get props => [];
}
