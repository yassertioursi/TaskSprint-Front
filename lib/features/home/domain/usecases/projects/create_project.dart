import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_application_1/features/home/domain/repositories/projects_repository.dart';


class CreateProjectUseCase {
  final ProjectsRepository repository;

  CreateProjectUseCase(this.repository);

  Future<Either<Failure, ProjectEntity>> call(ProjectEntity project) async {
    return await repository.createProject(project);
  }
}