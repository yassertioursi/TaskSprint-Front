import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime endTimestamp;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.endTimestamp,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        endTimestamp,
        userId,
        createdAt,
        updatedAt,
      ];
}