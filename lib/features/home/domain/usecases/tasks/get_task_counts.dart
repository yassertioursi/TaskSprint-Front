import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task_counts.dart';
import 'package:flutter_application_1/features/home/domain/repositories/tasks_repository.dart';

class GetTaskCountsUseCase {
  final TasksRepository repository;

 GetTaskCountsUseCase(this.repository);

  Future<Either<Failure, TaskCounts>> call() async {
    return await repository.getTaskCounts() ; 
  }
}