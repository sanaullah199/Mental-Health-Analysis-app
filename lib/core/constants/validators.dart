class Validators {
  /// Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  /// Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }

    // Optional: add more rules for stronger passwords
    // final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    // final hasDigits = value.contains(RegExp(r'\d'));
    // final hasLowercase = value.contains(RegExp(r'[a-z]'));
    // final hasSpecialCharacters = value.contains(RegExp(r'[!@#\$&*~]'));

    // if (!hasUppercase || !hasDigits || !hasLowercase || !hasSpecialCharacters) {
    //   return "Password must contain upper, lower, number & special char";
    // }

    return null; // ✅ Valid
  }

  /// Check if email is valid (returns boolean)
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
