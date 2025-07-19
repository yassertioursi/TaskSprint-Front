import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/navigation/app_routes.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/bloc/login_signup_bloc.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/curved_login_signup_header.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_signup_button.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_signup_form.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/login_signup_sub_texts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: BlocListener<LoginSignupBloc, LoginSignupState>(
        listener: _handleStateChanges,
        child: _buildBody(),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, LoginSignupState state) {
    switch (state) {
      case MessageLoginSignupState():
        _showSuccessMessage(state.message);
        _navigateToHome();
        break;
      case ErrorSignUpLoginState():
        _showErrorMessage(state.message);
        break;
      default:
        break;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.mainNavigation);
      }
    });
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const CurvedHeader(
              title: 'Welcome\nBack !',
              subtitle: 'Please Enter Your Credentials',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLoginForm(),
                  SizedBox(height: 30.h),
                  _buildLoginButton(),
                  SizedBox(height: 10.h),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            LoginSignupForm(
              controller: _emailController,
              isForPassword: false,
              isForPhoneNumber: false,
              maxLength: 100,
              validator: Validators.validateEmail,
              hintText: "Email",
            ),
            LoginSignupForm(
              controller: _passwordController,
              isForPassword: true,
              isForPhoneNumber: false,
              maxLength: 20,
              validator: Validators.validatePassword,
              hintText: "Password",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginSignupBloc, LoginSignupState>(
      builder: (context, state) {
        final isLoading = state is LoadingLoginSignup;
        
        return LoginSignupButton(
          buttonText: "Login",
          isLoading: isLoading,
          onPressed: _handleLogin,
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return LoginSignupSubTexts(
      question: "Don't have an account? ",
      routerTextButton: "Sign Up",
      onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginSignupBloc>().add(
        LoginEvent(
          user: UserAuth.forLogin(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        ),
      );
    }
  }
}
