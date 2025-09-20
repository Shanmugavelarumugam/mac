import 'package:btc_store/data/models/auth_model.dart';
import 'package:btc_store/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<RestoreSessionEvent>(_onRestoreSession);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("Login requested for email: ${event.email}");
    emit(AuthLoading());

    try {
      final response = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      print("Login response: ${response.message}");

      // ❌ If token or seller is missing → fail early
      if (response.token == null || response.seller == null) {
        emit(AuthFailure(response.message));
        print("Login failed: ${response.message}");
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.token!);
      await prefs.setInt('user_id', response.seller!.id);
      await prefs.setString('seller_name', response.seller!.name);

      print("Saved auth_token: ${response.token}");
      print("Saved user_id: ${response.seller!.id}");
      print("Saved seller_name: ${response.seller!.name}");

      emit(AuthSuccess(response));
      print("Login successful for user: ${response.seller!.name}");
    } catch (e) {
      emit(AuthFailure(e.toString()));
      print("Login exception: $e");
    }
  }


  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("Signup requested for email: ${event.email}");
    emit(AuthLoading());

    try {
      final response = await authRepository.register(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        businessName: event.businessName,
      );

      final prefs = await SharedPreferences.getInstance();

      // ✅ Save auth token, userId, and seller name after signup
      await prefs.setString('auth_token', response.token ?? '');
      await prefs.setInt('user_id', response.seller?.id ?? 0);
      await prefs.setString(
        'seller_name',
        response.seller?.name ?? 'Store Manager',
      );

      print("Saved auth_token: ${response.token}");
      print("Saved user_id: ${response.seller?.id}");
      print("Saved seller_name: ${response.seller?.name}");

      emit(AuthSuccess(response));
      print("Signup successful for user: ${response.seller?.name}");
    } catch (e) {
      emit(AuthFailure(e.toString()));
      print("Signup exception: $e");
    }
  }

  Future<void> _onRestoreSession(
    RestoreSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    print(
      "Restoring session for userId: ${event.userId}, token: ${event.token}",
    );
    // ✅ Emit AuthSuccess so all widgets get AuthBloc state
    emit(
      AuthSuccess(
        AuthResponse(
          token: event.token,
          seller: Seller(
            id: event.userId,
            name: 'Saved User', // placeholder, optionally fetch full info
            email: '',
            phone: null,
          ),
          message: 'Session restored',
        ),
      ),
    );
  }
}
