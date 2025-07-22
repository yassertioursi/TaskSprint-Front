import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';

@immutable
sealed class ProjectsState extends Equatable {
  const ProjectsState();
  
  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class LoadingProjects extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;
  
  const ProjectsLoaded({required this.projects});
  
  @override
  List<Object?> get props => [projects];
}

class ErrorProjectsState extends ProjectsState {
  final String message;
  
  const ErrorProjectsState({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class MessageProjectsState extends ProjectsState {
  final String message;
  
  const MessageProjectsState({required this.message});
  
  @override
  List<Object?> get props => [message];
}