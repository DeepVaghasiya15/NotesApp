import '../../Model/note_model.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent{
  final int userId;

  LoadNotes({required this.userId});

  List<Object?> get props => [userId];
}

class AddNote extends NotesEvent{
  final Note note;

  AddNote({required this.note});
}

class UpdateNote extends NotesEvent{
  final Note note;

  UpdateNote(Note updatedNote, {required this.note});
}

class DeleteNote extends NotesEvent{
  final int noteId;

  DeleteNote({required this.noteId});
}