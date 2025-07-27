import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/entities/task_counts.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(DateTime? date, {String? status});
  Future<Either<Failure, TaskCounts>> getTaskCounts();
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, Unit>> deleteTask(int id);
}