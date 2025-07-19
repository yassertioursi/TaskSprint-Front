part of 'login_signup_bloc.dart';

@immutable
sealed class LoginSignupEvent extends Equatable {
  const LoginSignupEvent();
}

class LoginEvent extends LoginSignupEvent {
  final UserAuth user;
  const LoginEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignupEvent extends LoginSignupEvent {
  final UserAuth user;
  const SignupEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
