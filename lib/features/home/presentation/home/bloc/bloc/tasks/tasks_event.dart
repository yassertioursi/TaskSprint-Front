import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class TasksEvent extends Equatable {
  const TasksEvent();
}

class GetTasksEvent extends TasksEvent {
  final DateTime? date;

  const GetTasksEvent({this.date});

  @override
  List<Object?> get props => [date];
}

class GetTaskCountsEvent extends TasksEvent {
  const GetTaskCountsEvent();

  @override
  List<Object?> get props => [];
}
