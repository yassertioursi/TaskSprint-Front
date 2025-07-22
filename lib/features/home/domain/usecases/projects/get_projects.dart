import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_application_1/features/home/domain/repositories/projects_repository.dart';

class GetProjectsUseCase {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  Future<Either<Failure, List<ProjectEntity>>> call() async {
    return await repository.getProjects();
  }
}