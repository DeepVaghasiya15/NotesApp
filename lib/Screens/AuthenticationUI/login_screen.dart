import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_bloc.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_event.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_state.dart';
import 'package:note_app/Screens/AuthenticationUI/register_screen.dart';
import 'package:note_app/Screens/notes_home.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // final TextEditingController usernameController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController(text: "Deep");
  final TextEditingController passwordController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc,AuthState>(
          listener: (context,state){
            if(state is Authenticated){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NotesHome()));
            }else if(state is AuthError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Notes",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color:Colors.orange),),
                  SizedBox(height: screenHeight * 0.12,),
                  Text("LogIn",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color:Colors.grey),),
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
                      hintText: "Enter Username",
                        suffixStyle: TextStyle(color: Colors.white)
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),
                  TextField(
                    obscureText: true,
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
                      hintText: "Enter Password",
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
                        context.read<AuthBloc>().add(LoginUser(username: username, password: password));
                      },
                      child: Text("Login")
                  ),
                  SizedBox(height: screenHeight * 0.03,),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                      },
                      child: Text("Don't have an account? Register",style: TextStyle(color: Colors.blue),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
