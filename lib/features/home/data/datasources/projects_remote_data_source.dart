import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/errors/exeptions.dart';
import 'package:flutter_application_1/features/home/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> createProject(ProjectModel project);
  Future<ProjectModel> updateProject(ProjectModel project);
  Future<void> deleteProject(int id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final Dio dio;

  ProjectRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProjectModel>> getProjects() async {
    try {
      final response = await dio.get(
        '/projects',
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['projects'] as List;
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        print(
            "Get projects failed with status ${response.statusCode}: $errorMessage");
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      print("DioException on get projects: $errorMessage");
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      print("General error on get projects: $e");
      throw const ServerException(message: "Failed to get projects");
    }
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    try {
      final response = await dio.post(
        '/projects',
        data: project.toCreateJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTI4NDkwNDEsImV4cCI6MTc1Mjg1MjY0MSwibmJmIjoxNzUyODQ5MDQxLCJqdGkiOiJ1cTBXeW91NnZZbmxlbmFoIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8M_iXTN6_C6iwluOGTS0YAMs7afaao-cyQQmzmIJRZs",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 201) {
        print("Create project successful: ${response.data}");
        return ProjectModel.fromJson(response.data['data']['project']);
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        print(
            "Create project failed with status ${response.statusCode}: $errorMessage");
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      print("DioException on create project: $errorMessage");
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      print("General error on create project: $e");
      throw const ServerException(message: "Failed to create project");
    }
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) async {
    try {
      final response = await dio.put(
        '/projects/${project.id}',
        data: project.toUpdateJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTI4NDkwNDEsImV4cCI6MTc1Mjg1MjY0MSwibmJmIjoxNzUyODQ5MDQxLCJqdGkiOiJ1cTBXeW91NnZZbmxlbmFoIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8M_iXTN6_C6iwluOGTS0YAMs7afaao-cyQQmzmIJRZs",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        print("Update project successful: ${response.data}");
        return ProjectModel.fromJson(response.data['data']['project']);
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        print(
            "Update project failed with status ${response.statusCode}: $errorMessage");
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      print("DioException on update project: $errorMessage");
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      print("General error on update project: $e");
      throw const ServerException(message: "Failed to update project");
    }
  }

  @override
  Future<void> deleteProject(int id) async {
    try {
      final response = await dio.delete(
        '/Projects/$id',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2F1dGgvbG9naW4iLCJpYXQiOjE3NTI4NDkwNDEsImV4cCI6MTc1Mjg1MjY0MSwibmJmIjoxNzUyODQ5MDQxLCJqdGkiOiJ1cTBXeW91NnZZbmxlbmFoIiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.8M_iXTN6_C6iwluOGTS0YAMs7afaao-cyQQmzmIJRZs",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        print("Delete Project successful: ${response.data}");
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        print(
            "Delete Project failed with status ${response.statusCode}: $errorMessage");
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      print("DioException on delete Project: $errorMessage");
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      print("General error on delete Project: $e");
      throw const ServerException(message: "Failed to delete project");
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
