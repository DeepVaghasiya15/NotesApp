import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_event.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_state.dart';
import '../../Model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';


class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final Box<User> userBox;

  AuthBloc(this.userBox) : super(AuthInitial()){
    on<RegisterUser>(_onRegisterUser);
    on<LoginUser>(_onLoginUser);
    on<LogoutUser>(_onLogoutUser);
  }

  void _onRegisterUser(RegisterUser event, Emitter<AuthState> emit) async {
    if(userBox.containsKey(event.username)){
      emit(AuthError(error: "Username already exists"));
    }else{
      final user = User(username: event.username,password: event.password);
      await userBox.put(event.username, user);
      emit(Authenticated(user: user));
    }
  }

  void _onLoginUser(LoginUser event, Emitter<AuthState> emit) async{
    final user = userBox.get(event.username);
    if(user != null && user.password == event.password){
      emit(Authenticated(user: user));
    }else{
      emit(AuthError(error: "Invalid Username or Password"));
    }
  }

  void _onLogoutUser(LogoutUser event, Emitter<AuthState> emit) async{
    emit(Unauthenticated());
  }
}

