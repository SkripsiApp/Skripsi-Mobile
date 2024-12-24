class SendOTP {
  final String email;

  SendOTP({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class VerifyOTP {
  final String email;
  final String otp;

  VerifyOTP({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

class ResetPassword {
  final String password;
  final String confirmPassword;

  ResetPassword({
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}
