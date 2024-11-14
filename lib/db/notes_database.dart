import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/note_model.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        userId TEXT NOT NULL
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copy(id: id, userId: null);
  }

  Future<List<Note>> readNotesByUserId(int userId) async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'notes',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      return result.map((json) => Note.fromMap(json)).toList();
    } catch (e) {
      print("Error querying notes for userId $userId: $e");
      rethrow;
    }
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [note.id, note.userId],
    );
  }

  Future<int> delete(int id, String userId) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }
}
