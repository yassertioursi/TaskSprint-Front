import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/usecases/tasks/create_task.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_event.dart';
import 'package:flutter_application_1/features/home/presentation/create_task/bloc/bloc/create_task_state.dart';




class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  final CreateTaskUseCase createTask;

  CreateTaskBloc({
    required this.createTask,
  }) : super(CreateTaskInitial()) {
    
    on<CreateTaskSubmitEvent>((event, emit) async {
      emit(CreatingTask());
      try {
        final failureOrSuccess = await createTask(event.task);
        emit(_mapFailureOrTaskToState(failureOrSuccess));
      } catch (e) {
        emit(const ErrorCreateTaskState(
            message: "An unexpected error occurred"));
      }
    });
  }

  CreateTaskState _mapFailureOrTaskToState(
      Either<Failure, TaskEntity> either) {
    return either.fold(
      (failure) => ErrorCreateTaskState(message: failure.message),
      (task) => TaskCreated(task: task),
    );
  }
}