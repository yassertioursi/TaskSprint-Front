import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/core/errors/failure.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/signup.dart';
import 'package:meta/meta.dart';

part 'login_signup_event.dart';
part 'login_signup_state.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginSignupState> {
  final LoginUseCase login;
  final SignupUseCase signup;

  LoginSignupBloc({required this.login, required this.signup})
      : super(LoginSignupInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingLoginSignup());
      try {
        final failureOrSuccess = await login(event.user);
        emit(_mapFailureOrSuccessToState(failureOrSuccess, "Logged In"));
      } catch (e) {
        emit(const ErrorSignUpLoginState(
            message: "An unexpected error occurred"));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(LoadingLoginSignup());
      try {
        final failureOrSuccess = await signup(event.user);
        emit(_mapFailureOrSuccessToState(failureOrSuccess, "Signed Up"));
      } catch (e) {
        emit(const ErrorSignUpLoginState(
            message: "An unexpected error occurred"));
      }
    });
  }

  LoginSignupState _mapFailureOrSuccessToState(
      Either<Failure, Unit> either, String successMessage) {
    return either.fold(
      (failure) => ErrorSignUpLoginState(message: failure.message),
      (_) => MessageLoginSignupState(message: successMessage),
    );
  }
}
