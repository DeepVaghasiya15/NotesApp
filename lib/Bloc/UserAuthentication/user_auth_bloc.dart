import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_event.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_state.dart';
import '../../Model/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Box<User> userBox;
  static const String authKey = "authenticatedUser";

  AuthBloc(this.userBox) : super(AuthInitial()) {
    on<RegisterUser>(_onRegisterUser);
    on<LoginUser>(_onLoginUser);
    on<LogoutUser>(_onLogoutUser);

    _checkAuthenticatedUser();
  }

  void _checkAuthenticatedUser() {
    final user = userBox.get(authKey);
    if (user != null) {
      print("Authenticated user ID: ${user.id}");
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onRegisterUser(RegisterUser event, Emitter<AuthState> emit) async {
    if (userBox.containsKey(event.username)) {
      emit(AuthError(error: "Username already exists"));
    } else {
      final userId = userBox.length + 1;
      final user = User(username: event.username, password: event.password, id: userId);

      await userBox.put(event.username, user);
      Hive.box('settingsBox').put('userId', userId);
      emit(Authenticated(user: user));
    }
  }


  void _onLoginUser(LoginUser event, Emitter<AuthState> emit) async {
    final user = userBox.get(event.username);
    if (user != null && user.password == event.password) {
      Hive.box('settingsBox').put('userId', user.id);
      emit(Authenticated(user: user));

      final userId = user.id;
    } else {
      emit(AuthError(error: "Invalid Username or Password"));
    }
  }

  void _onLogoutUser(LogoutUser event, Emitter<AuthState> emit) async {
    await userBox.delete(authKey);
    // Hive.box('settingsBox').delete('userId');
    emit(Unauthenticated());
  }
}
