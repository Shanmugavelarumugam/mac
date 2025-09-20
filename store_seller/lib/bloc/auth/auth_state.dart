import 'package:btc_store/data/models/auth_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthResponse response;
  AuthSuccess(this.response);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
