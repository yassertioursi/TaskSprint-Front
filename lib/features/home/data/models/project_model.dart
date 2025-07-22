import '../../domain/entities/project.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.endTimestamp,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      endTimestamp: DateTime.parse(json['end_timestamp']),
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
  
      'end_timestamp': endTimestamp.toIso8601String(),
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'end_timestamp': endTimestamp.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      'end_timestamp': endTimestamp.toIso8601String(),
    };
  }

  ProjectModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}