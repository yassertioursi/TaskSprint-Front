import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();
}

class GetProjectsEvent extends ProjectsEvent {
  const GetProjectsEvent();
  
  @override
  List<Object?> get props => [];
}