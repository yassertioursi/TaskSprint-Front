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

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        _navigateToLogin();
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

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          const CurvedHeader(
            title: 'Create your\nAccount',
            subtitle: 'Registration is fast and free!',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
              child: Column(
                children: [
                  _buildSignupForm(),
                  SizedBox(height: 30.h),
                  _buildSignupButton(),
                  SizedBox(height: 10.h),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LoginSignupForm(
            controller: _nameController,
            hintText: "Full Name",
            isForPassword: false,
            isForPhoneNumber: false,
            maxLength: 50,
            validator: Validators.validateName,
          ),
          LoginSignupForm(
            controller: _emailController,
            hintText: "Email",
            isForPassword: false,
            isForPhoneNumber: false,
            maxLength: 100,
            validator: Validators.validateEmail,
          ),
  
          LoginSignupForm(
            controller: _passwordController,
            hintText: 'Password',
            isForPassword: true,
            isForPhoneNumber: false,
            maxLength: 20,
            validator: Validators.validatePassword,
          ),
          LoginSignupForm(
            controller: _confirmPasswordController,
            hintText: 'Confirm Password',
            isForPassword: true,
            isForPhoneNumber: false,
            maxLength: 20,
            validator: _validateConfirmPassword,
          ),
        ],
      ),
    );
  }

  String? _validateConfirmPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildSignupButton() {
    return BlocBuilder<LoginSignupBloc, LoginSignupState>(
      builder: (context, state) {
        final isLoading = state is LoadingLoginSignup;
        
        return LoginSignupButton(
          buttonText: "Register",
          isLoading: isLoading,
          onPressed: _handleSignup,
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return LoginSignupSubTexts(
      question: "Already have an account? ",
      routerTextButton: "Login",
      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginSignupBloc>().add(
        SignupEvent(
          user: UserAuth.forSignup(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            passwordconfirmation: _confirmPasswordController.text,
      
          ),
        ),
      );
    }
  }
}
