import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/Bloc/Notes/notes_bloc.dart';
import 'package:note_app/Bloc/Notes/notes_event.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_bloc.dart';
import 'package:note_app/Screens/AuthenticationUI/login_screen.dart';
import 'package:note_app/Screens/notes_home.dart';
import 'package:note_app/Model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    final userBox = await Hive.openBox<User>('users');
    runApp(MyApp(userBox: userBox,));
  } catch (e) {
    if (kDebugMode) {
      print("Error initializing Hive: $e");
    }
  }
}

class MyApp extends StatelessWidget {
  final Box<User> userBox;

  const MyApp({super.key, required this.userBox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(userBox),
        ),
        BlocProvider<NotesBloc>(
            create: (context) => NotesBloc()..add(LoadNotes())
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}