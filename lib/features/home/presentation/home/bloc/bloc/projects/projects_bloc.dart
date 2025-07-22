import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_application_1/features/home/domain/usecases/projects/get_projects.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/projects/projects_event.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/projects/projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjectsUseCase getProjects;

  ProjectsBloc({
    required this.getProjects,
  }) : super(ProjectsInitial()) {
    
    on<GetProjectsEvent>((event, emit) async {
      emit(LoadingProjects());
      try {
        final failureOrSuccess = await getProjects();
        emit(_mapFailureOrProjectsToState(failureOrSuccess));
      } catch (e) {
        emit(const ErrorProjectsState(
            message: "An unexpected error occurred"));
      }
    });
  }

  ProjectsState _mapFailureOrProjectsToState(
      Either<Failure, List<ProjectEntity>> either) {
    return either.fold(
      (failure) => ErrorProjectsState(message: failure.message),
      (projects) => ProjectsLoaded(projects: projects),
    );
  }
}