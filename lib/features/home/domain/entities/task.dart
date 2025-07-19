import 'package:equatable/equatable.dart';

enum TaskEntityStatus { toDo, inProgress, done }

class TaskEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime startTimestamp;
  final DateTime endTimestamp;
  final TaskEntityStatus status;
  final int projectId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.status,
    required this.projectId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [
        id,
        title,
        description,
        startTimestamp,
        endTimestamp,
        status,
        projectId,
        userId,
        createdAt,
        updatedAt,
      ];
}
