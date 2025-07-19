import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/usecases/get_tasks.dart';

import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_event.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks_state.dart';



class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasksUseCase getTasks;

  TasksBloc({
    required this.getTasks,
 
  }) : super(TasksInitial()) {
    
    on<GetTasksEvent>((event, emit) async {
      emit(LoadingTasks());
      try {
        final failureOrSuccess = await getTasks();
        emit(_mapFailureOrTasksToState(failureOrSuccess));
      } catch (e) {
        emit(const ErrorTasksState(
            message: "An unexpected error occurred"));
      }
    });

  }

  TasksState _mapFailureOrTasksToState(
      Either<Failure, List<TaskEntity>> either) {
    return either.fold(
      (failure) => ErrorTasksState(message: failure.message),
      (tasks) => TasksLoaded(tasks: tasks),
    );
  }
}