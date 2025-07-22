import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/exeptions.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/core/network/network_info.dart';
import 'package:flutter_application_1/features/home/data/datasources/projects_remote_data_source.dart';
import 'package:flutter_application_1/features/home/data/models/project_model.dart';
import 'package:flutter_application_1/features/home/domain/entities/project.dart';
import 'package:flutter_application_1/features/home/domain/repositories/projects_repository.dart';

class ProjectRepositoryImpl implements ProjectsRepository {
  final ProjectRemoteDataSource projectRemoteDataSource;
  final NetworkInfo networkInfo;

  ProjectRepositoryImpl({
    required this.projectRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    if (await networkInfo.isConnected) {
      try {
        final projects = await projectRemoteDataSource.getProjects();
        return Right(projects);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject(ProjectEntity project) async {
    if (await networkInfo.isConnected) {
      try {
        final projectModel = ProjectModel(
          id: project.id,
          title: project.title,
          description: project.description,

          endTimestamp: project.endTimestamp,
          userId: project.userId,
          createdAt: project.createdAt,
          updatedAt: project.updatedAt,
        );

        final createdProject = await projectRemoteDataSource.createProject(projectModel);
        return Right(createdProject);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> updateProject(ProjectEntity project) async {
    if (await networkInfo.isConnected) {
      try {
        final projectModel = ProjectModel(
          id: project.id,
          title: project.title,
          description: project.description,
          endTimestamp: project.endTimestamp,
          userId: project.userId,
          createdAt: project.createdAt,
          updatedAt: project.updatedAt,
        );

        final updatedProject = await projectRemoteDataSource.updateProject(projectModel);
        return Right(updatedProject);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await projectRemoteDataSource.deleteProject(id);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}