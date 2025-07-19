import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> signup(UserAuth user);
  Future<Either<Failure, Unit>> login(UserAuth user);
}
