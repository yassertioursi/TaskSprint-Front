import 'package:flutter_application_1/features/home/domain/entities/task_counts.dart';

class TaskCountsModel extends TaskCounts {
  const TaskCountsModel({
    required super.total,
    required super.toDo,
    required super.inProgress,
    required super.done,
  });

  factory TaskCountsModel.fromJson(Map<String, dynamic> json) {
    final counts = json['counts'] as Map<String, dynamic>;
    
    return TaskCountsModel(
      total: counts['total'] ?? 0,
      toDo: counts['to_do'] ?? 0,
      inProgress: counts['in_progress'] ?? 0,
      done: counts['done'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'counts': {
        'total': total,
        'to_do': toDo,
        'in_progress': inProgress,
        'done': done,
      }
    };
  }

  TaskCountsModel copyWith({
    int? total,
    int? toDo,
    int? inProgress,
    int? done,
  }) {
    return TaskCountsModel(
      total: total ?? this.total,
      toDo: toDo ?? this.toDo,
      inProgress: inProgress ?? this.inProgress,
      done: done ?? this.done,
    );
  }
}