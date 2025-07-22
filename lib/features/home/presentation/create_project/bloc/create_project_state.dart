import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';

@immutable
sealed class CreateProjectState extends Equatable {
  const CreateProjectState();
  
  @override
  List<Object?> get props => [];
}

class CreateProjectInitial extends CreateProjectState {}

class CreatingProject extends CreateProjectState {}

class ProjectCreated extends CreateProjectState {
  final ProjectEntity project;
  
  const ProjectCreated({required this.project});
  
  @override
  List<Object?> get props => [project];
}

class ErrorCreateProjectState extends CreateProjectState {
  final String message;
  
  const ErrorCreateProjectState({required this.message});
  
  @override
  List<Object?> get props => [message];
}