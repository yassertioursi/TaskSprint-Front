import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/home/domain/entities/task.dart';
import 'package:flutter_application_1/features/home/domain/entities/task_counts.dart';
import 'package:flutter_application_1/features/home/domain/usecases/tasks/get_tasks.dart';
import 'package:flutter_application_1/features/home/domain/usecases/tasks/get_task_counts.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_event.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetTasksUseCase getTasks;
  final GetTaskCountsUseCase getTaskCounts;

  TasksBloc({
    required this.getTasks,
    required this.getTaskCounts,
  }) : super(const TasksAndCountsState()) {
    on<GetTasksEvent>((event, emit) async {
      emit(LoadingTasks()); // Emit loading state immediately!

      try {
        final failureOrSuccess = await getTasks(event.date,  event.status);

        failureOrSuccess.fold(
          (failure) => emit(ErrorTasksState(message: failure.message)),
          (tasks) => emit(TasksAndCountsState(
            tasks: tasks,
            isLoadingTasks: false,
          )),
        );
      } catch (e) {
        emit(const ErrorTasksState(message: "An unexpected error occurred"));
      }
    });

    on<GetTaskCountsEvent>((event, emit) async {
      final currentState = state;
      TasksAndCountsState newState;

      if (currentState is TasksAndCountsState) {
        newState = currentState.copyWith(isLoadingCounts: true);
      } else {
        newState = const TasksAndCountsState(isLoadingCounts: true);
      }
      emit(newState);

      try {
        final failureOrSuccess = await getTaskCounts();

        failureOrSuccess.fold(
          (failure) => emit(ErrorTasksState(message: failure.message)),
          (taskCounts) {
            if (state is TasksAndCountsState) {
              final currentState = state as TasksAndCountsState;
              emit(currentState.copyWith(
                taskCounts: taskCounts,
                isLoadingCounts: false,
              ));
            } else {
              emit(TasksAndCountsState(
                taskCounts: taskCounts,
                isLoadingCounts: false,
              ));
            }
          },
        );
      } catch (e) {
        emit(const ErrorTasksState(
            message:
                "An unexpected error occurred while fetching task counts"));
      }
    });
  }
}
