import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/Bloc/Notes/notes_event.dart';
import 'package:note_app/Bloc/Notes/notes_state.dart';
import 'package:note_app/Bloc/UserAuthentication/user_auth_bloc.dart';
import 'package:note_app/db/notes_database.dart';
import 'package:hive/hive.dart';


class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesDatabase _notesDatabase = NotesDatabase.instance;

  NotesBloc({required AuthBloc authBloc}) : super(NotesInitial()) {
    on<LoadNotes>((event, emit) async {
      if (!Hive.isBoxOpen('settingsBox')) {
        await Hive.openBox('settingsBox');
      }

      final userId = Hive.box('settingsBox').get('userId');
      if (userId == null || userId is! int) {
        emit(NotesError(message: "User not logged in, cannot load notes"));
        return;
      }

      emit(NotesLoading());
      try {
        final notes = await _notesDatabase.readNotesByUserId(userId);
        emit(NotesLoaded(notes: notes));
      } catch (e, stackTrace) {
        print("Error while loading notes: $e");
        print("Stack trace: $stackTrace");
        emit(NotesError(message: "Failed to load notes: ${e.toString()}"));
      }
    });


    on<AddNote>((event, emit) async {
      final userId = Hive.box('settingsBox').get('userId');
      if (userId == null || userId is! int) {
        emit(NotesError(message: "User not logged in"));
        return;
      }

      try {
        final note = event.note.copy(userId: userId);
        await _notesDatabase.create(note);

        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<UpdateNote>((event, emit) async {
      final userId = Hive.box('settingsBox').get('userId');
      if (userId == null || userId is! int) {
        emit(NotesError(message: "User not logged in"));
        return;
      }

      try {
        final note = event.note.copy(userId: userId);
        await _notesDatabase.update(note);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });

    on<DeleteNote>((event, emit) async {
      final userId = Hive.box('settingsBox').get('userId');
      if (userId == null || userId is! int) {
        emit(NotesError(message: "User not logged in"));
        return;
      }

      try {
        await _notesDatabase.delete(event.noteId, userId as String);
        add(LoadNotes());
      } catch (e) {
        emit(NotesError(message: e.toString()));
      }
    });


  }
}
