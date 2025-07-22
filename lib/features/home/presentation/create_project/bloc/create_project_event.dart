import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';

@immutable
sealed class CreateProjectEvent extends Equatable {
  const CreateProjectEvent();
}

class CreateProjectSubmitEvent extends CreateProjectEvent {
  final ProjectEntity project;
  
  const CreateProjectSubmitEvent({required this.project});

  @override
  List<Object?> get props => [project];
}