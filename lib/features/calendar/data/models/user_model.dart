import 'package:flutter_application_1/features/auth/domain/entities/user.dart';

class UserAuthModel extends UserAuth {
  const UserAuthModel(
    super.fullName,
    super.email,
    super.phoneNumber,
    super.password,
    super.passwordconfirmation, {
    required super.id,
  });

 
  const UserAuthModel.forLogin({
    required String email,
    required String password,
    int id = 0,
  }) : super.forLogin(email: email, password: password, id: id);

  
  const UserAuthModel.forSignup({
    required String fullName,
    required String email,
    required String password,
    required String passwordconfirmation,
    String phoneNumber = "",
    int id = 0,
  }) : super.forSignup(
          fullName: fullName,
          email: email,
          password: password,
          passwordconfirmation: passwordconfirmation,
          phoneNumber: phoneNumber,
          id: id,
        );

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      json['fullName'] ?? '',
      json['email'] ?? '',
      json['phoneNumber'] ?? '',
      json['password'] ?? '',
      json['passwordconfirmation'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': fullName, 
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      "password_confirmation": passwordconfirmation,
    };
  }

 
  Map<String, dynamic> toLoginJson() {
    return {
      'email': email,
      'password': password,
    };
  }

 
  Map<String, dynamic> toSignupJson() {
    return {
      'name': fullName,
      'email': email,
      'password': password,
      'password_confirmation': passwordconfirmation,
    };
  }
}