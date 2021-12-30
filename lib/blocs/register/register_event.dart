import 'package:ecommerce_app/data/models/models.dart';
import 'package:equatable/equatable.dart';
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

/// When user changes email
class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'EmailChanged{email: $email}';
  }
}

/// When user changes phone
class PhoneChanged extends RegisterEvent {
  final String phone;

  const PhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() {
    return 'PhoneChanged{phone: $phone}';
  }
}


/// When user changes password
class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  String toString() {
    return 'PasswordChanged{password: $password}';
  }
}

/// When user changes confirmed password
class ConfirmPasswordChanged extends RegisterEvent {
  final String password;
  final String confirmPassword;

  ConfirmPasswordChanged(
      {required this.password, required this.confirmPassword});

  @override
  String toString() {
    return 'ConfirmPasswordChanged{password: $password ,confirmPassword: $confirmPassword}';
  }
}

/// When clicks to register button
class Submitted extends RegisterEvent {
  final UserModel newUser; // contains new user's information
  final String password;
  final String confirmPassword;

  const Submitted({
    required this.newUser,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [newUser.email];

  @override
  String toString() {
    return 'Submitted{email: ${newUser.email}, password: $password, confirmPassword: $confirmPassword}';
  }
}
