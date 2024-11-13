import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/Bloc/Notes/notes_bloc.dart';
import 'package:note_app/Bloc/Notes/notes_event.dart';

import '../Model/note_model.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text("Add Note",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.orange[400]),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                final note = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  id: null,
                );
                context.read<NotesBloc>().add(AddNote(note: note));
                Navigator.pop(context);
              },
              icon: Icon(Icons.check,color: Colors.white,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white,fontSize: 23),
              decoration: InputDecoration(
                  labelText: "Title",
                labelStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                border: InputBorder.none
              ),
            ),
            Divider(),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white,fontSize: 20),
                keyboardType: TextInputType.multiline,
                expands: true,
                minLines: null,
                maxLines: null,
                controller: _contentController,
                decoration: InputDecoration(
                    labelText: "Content",
                    labelStyle: TextStyle(fontSize: 23,),
                  border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
