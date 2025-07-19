import '../../domain/entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startTimestamp,
    required super.endTimestamp,
    required super.status,
    required super.projectId,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTimestamp: DateTime.parse(json['start_timestamp']),
      endTimestamp: DateTime.parse(json['end_timestamp']),
      status: _parseStatus(json['status']),
      projectId: json['project_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_timestamp': startTimestamp.toIso8601String(),
      'end_timestamp': endTimestamp.toIso8601String(),
      'status': _statusToString(status),
      'project_id': projectId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'start_timestamp': startTimestamp.toIso8601String(),
      'end_timestamp': endTimestamp.toIso8601String(),
      'status': _statusToString(status),
      'project_id': projectId,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      'start_timestamp': startTimestamp.toIso8601String(),
      'end_timestamp': endTimestamp.toIso8601String(),
      'status': _statusToString(status),
      'project_id': projectId,
    };
  }

  static TaskEntityStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'todo':
        return TaskEntityStatus.toDo;
      case 'in_progress':
        return TaskEntityStatus.inProgress;
      case 'done':
        return TaskEntityStatus.done;
      default:
        return TaskEntityStatus.toDo;
    }
  }

  static String _statusToString(TaskEntityStatus status) {
    switch (status) {
      case TaskEntityStatus.toDo:
        return 'todo';
      case TaskEntityStatus.inProgress:
        return 'in_progress';
      case TaskEntityStatus.done:
        return 'done';
    }
  }

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    TaskEntityStatus? status,
    int? projectId,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
