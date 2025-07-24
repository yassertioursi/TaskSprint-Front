import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/exeptions.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/core/network/network_info.dart';
import 'package:flutter_application_1/features/home/data/datasources/tasks_remote_data_source.dart';
import 'package:flutter_application_1/features/home/data/models/task_model.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/entities/task_counts.dart';
import 'package:flutter_application_1/features/home/domain/repositories/tasks_repository.dart';

class TaskRepositoryImpl implements TasksRepository {
  final TaskRemoteDataSource taskRemoteDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.taskRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(DateTime? date) async {
    if (await networkInfo.isConnected) {
      try {
        final tasks = await taskRemoteDataSource.getTasks(date);
        return Right(tasks);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }


  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    if (await networkInfo.isConnected) {
      try {
        final taskModel = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          startTimestamp: task.startTimestamp,
          endTimestamp: task.endTimestamp,
          status: task.status,
          projectId: task.projectId,
          userId: task.userId,
          createdAt: task.createdAt,
          updatedAt: task.updatedAt,
        );

        final createdTask = await taskRemoteDataSource.createTask(taskModel);
        return Right(createdTask);
      } on ServerException catch (e) {
        return Left(ServerFailure( e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    if (await networkInfo.isConnected) {
      try {
        final taskModel = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          startTimestamp: task.startTimestamp,
          endTimestamp: task.endTimestamp,
          status: task.status,
          projectId: task.projectId,
          userId: task.userId,
          createdAt: task.createdAt,
          updatedAt: task.updatedAt,
        );

        final updatedTask = await taskRemoteDataSource.updateTask(taskModel);
        return Right(updatedTask);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(int id) async {
    if (await networkInfo.isConnected) {
      try {
        await taskRemoteDataSource.deleteTask(id);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure( e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, TaskCounts>> getTaskCounts() async {
    if (await networkInfo.isConnected) {
      try {
        final taskCounts = await taskRemoteDataSource.getTaskCounts();
        return Right(taskCounts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}