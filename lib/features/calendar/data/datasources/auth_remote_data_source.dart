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
  final loginData = user.toLoginJson();
  print("Sending login data: $loginData"); 
    try {
      final response = await dio.post(
        "/auth/login",
        data:user.toLoginJson() , 
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        
        return Future.value(unit);
      } else {
      
      
        throw ServerException();
      }
    } catch (e) {
      print("Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> signup(UserAuthModel user) async {
    final body = {
      "email": user.email,
      "password": user.password,
      "name": user.fullName,
     
      "phone_number": user.phoneNumber,
      "password_confirmation": user.passwordconfirmation,
    };
    try {
      
      final response = await dio.post(
        "/register",
        data: body,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else {
        print("Error: ${response.statusCode}");
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
