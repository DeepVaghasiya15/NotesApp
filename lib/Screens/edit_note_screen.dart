import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/Notes/notes_bloc.dart';
import '../Bloc/Notes/notes_event.dart';
import '../Model/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text("Edit Note",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.orange[400]),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                final updatedNote = Note(
                  id: widget.note.id,
                  title: _titleController.text,
                  content: _contentController.text,
                );
                context.read<NotesBloc>().add(UpdateNote(updatedNote, note: updatedNote));
                Navigator.pop(context);
              },
              icon: Icon(Icons.check,color: Colors.white,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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

