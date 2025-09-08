import 'package:equatable/equatable.dart';
abstract class AuthEvent extends Equatable { const AuthEvent(); }
class LoginRequested extends AuthEvent {
  final String email, password, role;
  LoginRequested(this.email, this.password, this.role);
  @override List<Object?> get props => [email, password, role];
}
class LogoutRequested extends AuthEvent {
  @override List<Object?> get props => [];
}