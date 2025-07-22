import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/repositories/tasks_repository.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call() async {
    return await repository.getTasks();
  }
}