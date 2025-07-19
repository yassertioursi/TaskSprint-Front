import 'package:email_validator/email_validator.dart';

class Validators {
  static String? _isNullOrEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is  required";
    }
    return null;
  }

  static String? validateEmail(String? email) {
    final String? nullCheckMessage = _isNullOrEmpty(email, "email");
    if (nullCheckMessage != null) {
      return nullCheckMessage;
    }
    if (!EmailValidator.validate(email!)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    final String? nullCheckMessage = _isNullOrEmpty(password, "password");
    if (nullCheckMessage != null) {
      return nullCheckMessage;
    }
    if (password!.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  static String? validateName(String? name) {
    final String? nullCheckMessage = _isNullOrEmpty(name, "name");
    if (nullCheckMessage != null) {
      return nullCheckMessage;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name!)) {
      return "Name can only contain letters and spaces";
    }

    if (name.length < 2 || name.length > 50) {
      return "Name must be between 2 and 50 characters";
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {
    final String? nullCheckMessage =
        _isNullOrEmpty(phoneNumber, "Phone Number");
    if (nullCheckMessage != null) {
      return nullCheckMessage;
    }

    final RegExp phoneRegExp = RegExp(
      r'^\+?[0-9]{1,3}?[-. ]?(\(?\d{1,4}?\)?[-. ]?)?\d{1,4}[-. ]?\d{1,4}[-. ]?\d{1,9}$',
    );

    if (!phoneRegExp.hasMatch(phoneNumber!)) {
      return "Enter a valid phone number";
    }
    return null;
  }
}
