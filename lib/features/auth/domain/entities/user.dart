import 'package:equatable/equatable.dart';

class UserAuth extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String passwordconfirmation;

  const UserAuth(
    this.fullName,
    this.email,
    this.phoneNumber,
    this.password,
    this.passwordconfirmation, {
    required this.id,
  });

  // Named constructor for login (only requires email and password)
  const UserAuth.forLogin({
    required this.email,
    required this.password,
    this.id = 0,
  }) : fullName = "",
       phoneNumber = "",
       passwordconfirmation = "";

  // Named constructor for signup
  const UserAuth.forSignup({
    required this.fullName,
    required this.email,
    required this.password,
    required this.passwordconfirmation,
    this.phoneNumber = "",
    this.id = 0,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        password,
        passwordconfirmation
      ];

  @override
  bool? get stringify => true;
}