import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_application_1/features/home/domain/usecases/projects/create_project.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/bloc/create_project_event.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/bloc/create_project_state.dart';

class CreateProjectBloc extends Bloc<CreateProjectEvent, CreateProjectState> {
  final CreateProjectUseCase createProject;

  CreateProjectBloc({
    required this.createProject,
  }) : super(CreateProjectInitial()) {
    
    on<CreateProjectSubmitEvent>((event, emit) async {
      emit(CreatingProject());
      try {
        final failureOrSuccess = await createProject(event.project);
        emit(_mapFailureOrProjectToState(failureOrSuccess));
      } catch (e) {
        emit(const ErrorCreateProjectState(
            message: "An unexpected error occurred"));
      }
    });
  }

  CreateProjectState _mapFailureOrProjectToState(
      Either<Failure, ProjectEntity> either) {
    return either.fold(
      (failure) => ErrorCreateProjectState(message: failure.message),
      (project) => ProjectCreated(project: project),
    );
  }
}