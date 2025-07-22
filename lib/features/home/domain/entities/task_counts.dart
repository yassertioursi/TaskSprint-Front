import 'package:equatable/equatable.dart';

class TaskCounts extends Equatable {
  final int total;
  final int toDo;
  final int inProgress;
  final int done;

  const TaskCounts({
    required this.total,
    required this.toDo,
    required this.inProgress,
    required this.done,
  });

  @override
  List<Object?> get props => [total, toDo, inProgress, done];

  @override
  String toString() {
    return 'TaskCounts(total: $total, toDo: $toDo, inProgress: $inProgress, done: $done)';
  }
}