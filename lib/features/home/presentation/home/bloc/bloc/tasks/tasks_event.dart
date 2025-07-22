
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class TasksEvent extends Equatable {
  const TasksEvent();
}

class GetTasksEvent extends TasksEvent 
  {
  const GetTasksEvent();
  
  @override

  List<Object?> get props => [];


}

