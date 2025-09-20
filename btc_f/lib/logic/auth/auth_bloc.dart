import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<SignOutRequested>(_onSignOutRequested); // ⬅️ Add this line
  }


  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(event.email, event.password);
      emit(AuthSuccess(user));
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data['message'] ?? 'Login failed';
        emit(AuthFailure(message));
      } else {
        emit(AuthFailure("Unexpected error"));
      }
    }
  }

  void _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await repository.signup(
        event.name,
        event.email,
        event.password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data['message'] ?? 'Signup failed';
        emit(AuthFailure(message));
      } else {
        emit(AuthFailure("Unexpected error"));
      }
    }
  }
}

void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) {
  emit(AuthInitial()); // Reset the state
}
