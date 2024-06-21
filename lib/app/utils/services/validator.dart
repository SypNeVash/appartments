class Validator {
  static String? validateDropDefaultData(value) {
    if (value == null) {
      return 'Please select an item.';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    String pattern = r'^(?=.*[A-Z])(?=.*[\W_]).{8,16}$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!regex.hasMatch(value)) {
      return 'Password must be 8-16 characters long,\ninclude at least one uppercase letter and one symbol';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validateText(String value) {
    if (value.isEmpty) {
      return '🚩 Text is too short.';
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String value) {
    if (value.length != 11) {
      return '🚩 Phone number is not valid.';
    } else {
      return null;
    }
  }
}
