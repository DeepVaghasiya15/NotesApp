abstract class AuthEvent{}

class RegisterUser extends AuthEvent{
  final String username;
  final String password;

  RegisterUser({
    required this.username,
    required this.password,
});
}

class LoginUser extends AuthEvent{
  final String username;
  final String password;

  LoginUser({
    required this.username,
    required this.password,
});
}

class LogoutUser extends AuthEvent{}