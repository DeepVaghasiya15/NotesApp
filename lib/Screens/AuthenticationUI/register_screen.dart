import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_bloc.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_event.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc,AuthState>(
          listener: (context,state) {
            if(state is Authenticated){
              Navigator.pop(context);
            }else if(state is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error))
              );
            }
          },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Register",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color:Colors.grey),),
                  SizedBox(height: screenHeight * 0.03,),
                  TextField(
                    style: TextStyle(color: Colors.white,fontSize: 23),
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 1)),
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.grey,fontSize: 20),
                      hintText: "Register Username",
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),
                  TextField(
                    style: TextStyle(color: Colors.white,fontSize: 23),
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 1)),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey,fontSize: 20),
                      hintText: "Register Password",
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        foregroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      onPressed: (){
                        final username = usernameController.text;
                        final password = passwordController.text;
                        context.read<AuthBloc>().add(RegisterUser(username: username, password: password));
                      },
                      child: Text("Register")
                  ),
                  SizedBox(height: screenHeight * 0.03,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
