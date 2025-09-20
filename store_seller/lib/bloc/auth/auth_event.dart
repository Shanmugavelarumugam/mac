import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String businessName;

  SignupRequested(
    this.name,
    this.email,
    this.phone,
    this.password,
    this.businessName,
  );
}

class RestoreSessionEvent extends AuthEvent {
  final String token;
  final int userId;

  RestoreSessionEvent({required this.token, required this.userId});

  @override
  List<Object?> get props => [token, userId];
}
