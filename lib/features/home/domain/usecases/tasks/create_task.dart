import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/repositories/tasks_repository.dart';

class CreateTaskUseCase {
  final TasksRepository repository;

  CreateTaskUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) async {
    return await repository.createTask(task);
  }
}