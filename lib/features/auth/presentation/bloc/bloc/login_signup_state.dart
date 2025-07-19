part of 'login_signup_bloc.dart';

@immutable
sealed class LoginSignupState extends Equatable {
  const LoginSignupState();
  @override
  List<Object?> get props => [];
}

class LoginSignupInitial extends LoginSignupState {}

class LoadingLoginSignup extends LoginSignupState {}

class ErrorSignUpLoginState extends LoginSignupState {
  final String message;
  const ErrorSignUpLoginState({
    required this.message,
  });
  @override
  List<Object?> get props =>
      [message]; // Include message in props for state equality
}

class MessageLoginSignupState extends LoginSignupState {
  final String message;
  const MessageLoginSignupState({
    required this.message,
  });
  @override
  List<Object?> get props =>
      [message]; // Include message in props for state equality
}
