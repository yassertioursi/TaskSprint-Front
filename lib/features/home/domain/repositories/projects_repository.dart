import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project);
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project);
  Future<Either<Failure, Unit>> deleteProject(int id);
}