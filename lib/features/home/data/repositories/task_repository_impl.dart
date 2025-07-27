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
  Future<Either<Failure, List<TaskEntity>>> getTasks(DateTime? date,
      {String? status}) async {
    try {
      if (await networkInfo.isConnected) {
        final tasks = await taskRemoteDataSource.getTasks(date, status: status);
        return Right(tasks);
      } else {
        return const Left(OfflineFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      if (await networkInfo.isConnected) {
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
      } else {
        return const Left(OfflineFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      if (await networkInfo.isConnected) {
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
      } else {
        return const Left(OfflineFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTask(int id) async {
    try {
      if (await networkInfo.isConnected) {
        await taskRemoteDataSource.deleteTask(id);
        return const Right(unit);
      } else {
        return const Left(OfflineFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskCounts>> getTaskCounts() async {
    try {
      if (await networkInfo.isConnected) {
        final taskCounts = await taskRemoteDataSource.getTaskCounts();
        return Right(taskCounts);
      } else {
        return const Left(OfflineFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
