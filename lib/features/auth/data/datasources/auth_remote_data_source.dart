import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/errors/exeptions.dart';
import 'package:flutter_application_1/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Unit> login(UserAuthModel user);
  Future<Unit> signup(UserAuthModel user);
}

class AuthRemoteImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteImpl({required this.dio});

  @override
  Future<Unit> login(UserAuthModel user) async {
    return _performAuthRequest("/auth/login", user.toLoginJson());
  }

  @override
  Future<Unit> signup(UserAuthModel user) async {
    
    return _performAuthRequest("/auth/register", user.toSignupJson());
  }

  Future<Unit> _performAuthRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("$endpoint successful: ${response.data}");
        return Future.value(unit);
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        print("$endpoint failed with status ${response.statusCode}: $errorMessage");
        throw ServerException(message: errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      print("DioException on $endpoint: $errorMessage");
      throw ServerException(message: errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      print("General error on $endpoint: $e");
      throw const ServerException(message: "An unexpected error occurred");
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData != null && responseData is Map<String, dynamic>) {
    
      if (responseData['errors'] != null && responseData['errors'] is Map) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        
        for (final fieldErrors in errors.values) {
          if (fieldErrors is List && fieldErrors.isNotEmpty) {
            return fieldErrors[0].toString();
          }
        }
      }
      
      return responseData['message'] ?? "Something went wrong";
    }
    
    return "Network error occurred";
  }
}
