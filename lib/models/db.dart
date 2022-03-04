import 'package:sqflite/sqflite.dart';
import './word.model.dart';

class DBConnect {
  Future<Database> database;
  DBConnect(this.database);
  Future<void> insertWord(Word word) async {
    final db = await database;

    await db.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Word>> words() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('words');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Word(
        id: maps[i]['id'],
        word: maps[i]['word'],
        meaning: maps[i]['meaning'],
      );
    });
  }

  Future<void> updateWord(Word word) async {
    final db = await database;

    await db.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> deleteWord(int id) async {
    final db = await database;
    await db.delete(
      'words',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
