abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignupRequested(this.name, this.email, this.password);
}
class SignOutRequested extends AuthEvent {}

