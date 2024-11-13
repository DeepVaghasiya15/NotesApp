import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/Bloc/Notes/notes_event.dart';
import 'package:note_app/Bloc/Notes/notes_state.dart';
import 'package:note_app/db/notes_database.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesDatabase _notesDatabase = NotesDatabase.instance;

  NotesBloc() : super(NotesInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NotesLoading());
      try {
        final notes = await _notesDatabase.readAllNotes();
        emit(NotesLoaded(notes: notes));
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<AddNote>((event, emit) async {
      try {
        await _notesDatabase.create(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        await _notesDatabase.update(event.note);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        await _notesDatabase.delete(event.noteId);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

  }
}
