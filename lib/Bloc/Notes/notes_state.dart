import '../../Model/note_model.dart';

abstract class NotesState {}

class NotesInitial extends NotesState{}

class NotesLoading extends NotesState{}

class NotesLoaded extends NotesState{
  final List<Note> notes;

  NotesLoaded({required this.notes});
}

class NotesError extends NotesState{
  final String message;

  NotesError({required this.message});
}