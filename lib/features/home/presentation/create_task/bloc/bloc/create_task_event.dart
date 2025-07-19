

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';

@immutable
sealed class CreateTaskEvent extends Equatable {
  const CreateTaskEvent();
}

class CreateTaskSubmitEvent extends CreateTaskEvent {
  final TaskEntity task;
  
  const CreateTaskSubmitEvent({required this.task});

  @override
  List<Object?> get props => [task];
}