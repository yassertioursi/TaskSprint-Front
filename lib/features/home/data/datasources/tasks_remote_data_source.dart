import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/errors/exeptions.dart';
import 'package:flutter_application_1/features/home/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<List<TaskModel>> getTasksByDate(DateTime date);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
       final response = await dio.get(
        '/tasks',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTI4NDkwNDEsImV4cCI6MTc1Mjg1MjY0MSwibmJmIjoxNzUyODQ5MDQxLCJqdGkiOiJ1cTBXeW91NnZZbmxlbmFoIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8M_iXTN6_C6iwluOGTS0YAMs7afaao-cyQQmzmIJRZs",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['tasks'] as List;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to get tasks');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    try {
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await dio.get('/tasks?date=$dateString');

      if (response.statusCode == 200) {
        final data = response.data['data']['tasks'] as List;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to get tasks by date');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Network error');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await dio.post(
        '/tasks',
        data: task.toCreateJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json"  ,
             "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTI4NDkwNDEsImV4cCI6MTc1Mjg1MjY0MSwibmJmIjoxNzUyODQ5MDQxLCJqdGkiOiJ1cTBXeW91NnZZbmxlbmFoIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8M_iXTN6_C6iwluOGTS0YAMs7afaao-cyQQmzmIJRZs", 
          
          
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 201) {
        return TaskModel.fromJson(response.data['data']['task']);
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException(message: "Failed to create task");
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await dio.put(
        '/tasks/${task.id}',
        data: task.toUpdateJson(),
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data['data']['task']);
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException(message: "Failed to update task");
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      final response = await dio.delete(
        '/tasks/$id',
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode != 200) {
        final errorMessage = _extractErrorMessage(response.data);
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException(message: "Failed to delete task");
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData != null && responseData is Map<String, dynamic>) {
      // Check for validation errors
      if (responseData['errors'] != null && responseData['errors'] is Map) {
        final errors = responseData['errors'] as Map<String, dynamic>;

        for (final fieldErrors in errors.values) {
          if (fieldErrors is List && fieldErrors.isNotEmpty) {
            return fieldErrors[0].toString();
          }
        }
      }

      // Check for general message
      return responseData['message'] ?? "Something went wrong";
    }

    return "Network error occurred";
  }
}
