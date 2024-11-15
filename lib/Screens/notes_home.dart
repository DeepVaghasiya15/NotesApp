import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:note_app/Bloc/Notes/notes_bloc.dart';
import 'package:note_app/Bloc/Notes/notes_event.dart';
import 'package:note_app/Bloc/Notes/notes_state.dart';
import 'package:note_app/Screens/AuthenticationUI/login_screen.dart';
import 'package:note_app/Screens/add_note_screen.dart';
import 'package:note_app/Screens/edit_note_screen.dart';

import '../Bloc/UserAuthentication/user_auth_bloc.dart';
import '../Bloc/UserAuthentication/user_auth_state.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  _NotesHomeState createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orange[400]),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text("Logout", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            final userId = state.user.id;

            if (userId != null) {
              context.read<NotesBloc>().add(LoadNotes(userId: userId));
            } else {
              print("User ID is null!");
            }
          }
        },
        child: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
          if (state is NotesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            final userId = Hive.box('settingsBox').get('userId');
            final userNotes = state.notes.where((note) => note.userId == userId).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
              ),
              padding: EdgeInsets.all(8.0),
              itemCount: userNotes.length,
              itemBuilder: (context, index) {
                final note = userNotes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(note: note),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  note.title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<NotesBloc>().add(DeleteNote(noteId: note.id!));
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                          Text(
                            note.content,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NotesError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text("No notes available", style: TextStyle(color: Colors.white)));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen()));
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

