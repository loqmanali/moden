import 'package:modn/core/localization/localization.dart';

/// A class to manage form validation logic for various input fields.
/// This class uses regular expressions to validate common fields like code, mobile number, name, email, and password.
class AppFormValidator {
  // Private constructor to prevent instantiation
  AppFormValidator._();

  // Singleton instance for accessing the validator
  static final AppFormValidator instance = AppFormValidator._();

  /// Validates if the input code is non-empty.
  ///
  /// **Parameters:**
  /// - `value`: The code to validate.
  ///
  /// **Return Value:**
  /// - Returns an error message if invalid, otherwise returns null.
  String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your Code';
    }
    return null;
  }

  /// Validates the mobile number format.
  ///
  /// **Parameters:**
  /// - `value`: The mobile number to validate.
  ///
  /// **Return Value:**
  /// - Returns an error message if invalid, otherwise returns null.
  String? validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter Your Number';
    }

    value = value.trim();
    // final RegExp arabicNumerals = RegExp(r'[٠١٢٣٤٥٦٧٨٩]');
    // final RegExp validNumberPattern = RegExp(r'^(?:\+?0?9)[0-9]{10,15}$');

    // // Check for valid number format
    // if (!validNumberPattern.hasMatch(value)) {
    //   return 'Please Enter Valid Number';
    // }
    if (value.length != 9) {
      return 'Phone Number Must Be 9 Digits';
    }
    if (!value.startsWith('5')) {
      return 'Phone Number Must Start With 5';
    }

    return null;
  }

  /// Validates if the input name meets certain criteria (length and valid characters).
  ///
  /// **Parameters:**
  /// - `value`: The name to validate.
  ///
  /// **Return Value:**
  /// - Returns an error message if invalid, otherwise returns null.
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This Field Is Empty';
    }

    // final RegExp namePattern = RegExp(r'^[a-zA-Z\u0600-\u06FF\s,.\-]+$');

    if (value.length < 2) {
      return 'Name Must Be At Least 2 Letters';
    } else if (value.length > 30) {
      return 'Name Must Be At Most 30 Letters';
    }

    return null;
  }

  /// Validates the email format.
  ///
  /// **Parameters:**
  /// - `value`: The email to validate.
  ///
  /// **Return Value:**
  /// - Returns an error message if invalid, otherwise returns null.
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.pleaseEnterYourEmail;
    }

    final RegExp emailPattern =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    if (!emailPattern.hasMatch(value)) {
      return L10n.pleaseEnterValidEmail;
    }

    return null;
  }

  /// Validates the password format (minimum length of 8 characters).
  ///
  /// **Parameters:**
  /// - `value`: The password to validate.
  ///
  /// **Return Value:**
  /// - Returns an error message if invalid, otherwise returns null.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.pleaseEnterYourPassword;
    } else if (value.length < 6) {
      return L10n.passwordMustBeAtLeast6Characters;
    }

    return null;
  }

  /// Validates the confirm password format.
  ///
  /// **Parameters:**
  /// - `value`: The confirm password to validate.
  /// - `password`: The password to validate.
  ///
  /// **Return Value:**
  /// - Returns an error message if invalid, otherwise returns null.
  String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Your Confirm Password';
    } else if (value != password) {
      return 'Passwords Do Not Match';
    }

    return null;
  }

  /// Checks if the given string is numeric.
  ///
  /// **Parameters:**
  /// - `str`: The string to check.
  ///
  /// **Return Value:**
  /// - Returns `true` if the string is numeric, `false` otherwise.
  bool isNumeric(String str) {
    return RegExp(r'^-?[0-9]+$').hasMatch(str);
  }
}
