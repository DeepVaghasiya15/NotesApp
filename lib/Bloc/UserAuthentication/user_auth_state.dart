import '../../Model/user.dart';

abstract class AuthState{}

class AuthInitial extends AuthState{}

class Authenticated extends AuthState{
  final User user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthState{}

class AuthError extends AuthState{
  final String error;
  AuthError({required this.error});
}
