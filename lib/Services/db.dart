import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/MyNoteModel.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Notes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = ' BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE ${NotesImpNames.tableName}(
      ${NotesImpNames.id} $idType,
      ${NotesImpNames.pin} $boolType,
      ${NotesImpNames.title} $textType,
      ${NotesImpNames.content} $textType,
      ${NotesImpNames.createdTime} $textType
    )
    ''');
  }

  Future<Note?> insertEntry(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(NotesImpNames.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NotesImpNames.createdTime} DESC';
    final queryResult =
        await db!.query(NotesImpNames.tableName, orderBy: orderBy);
    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesImpNames.tableName,
        columns: NotesImpNames.values,
        where: '${NotesImpNames.id} = ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future updateNote(Note note) async {
    final db = await instance.database;
    await db!.update(NotesImpNames.tableName, note.toJson(),
        where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }
  //To update pin
  Future updatePin(Note note) async {
    final db = await instance.database;
    await db!.update(NotesImpNames.tableName, {NotesImpNames.pin : !note.pin ?1:0},
        where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }
//To update Archive
  Future updateArchive(Note note) async {
    final db = await instance.database;
    await db!.update(NotesImpNames.tableName, {NotesImpNames.archive : !note.archive ?1:0},
        where: '${NotesImpNames.id} = ?', whereArgs: [note.id]);
  }

  Future deleteNote(Note note) async {
    final db = await instance.database;
    await db!.delete(NotesImpNames.tableName,
        where: '${NotesImpNames.id}= ?', whereArgs: [note.id]);
  }
  //For Search Results
  Future<List<Note>>getAllSearchNotes(String query)async{
    List<Note> result = [];
    final db = await instance.database;
    final table = await db!.query(NotesImpNames.tableName);

    table.forEach((element) {
      if(element["title"].toString().toLowerCase().contains(query) || element["content"].toString().toLowerCase().contains(query)){
        result.add(Note.fromJson(element));
      }
    });

    return result;
  }

  Future closeDB() async {
    final db = await instance.database;
    db!.close();
  }
}
