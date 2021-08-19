import 'package:movieflix/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MoviesDatabase {
  static final MoviesDatabase instance = MoviesDatabase._init();

  static Database? _database;

  MoviesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableMovies ( 
  ${MovieFields.id} $idType, 

 
  ${MovieFields.title} $textType,
  ${MovieFields.description} $textType, 
  ${MovieFields.posterpath} $textType)
 
 
''');
  }

  Future<Movie> create(Movie movie) async {
    final db = await instance.database;

    // final json = movie.toJson();
    // final columns =
    //     '${MovieFields.title}, ${MovieFields.description}, ${MovieFields.time}';
    // final values =
    //     '${json[MovieFields.title]}, ${json[MovieFields.description]}, ${json[MovieFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableMovies, movie.toJson());
    return movie.copy(id: id);
  }

  Future<Movie> readMovie(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMovies,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Movie>> readAllMovies() async {
    final db = await instance.database;

    final orderBy = '${MovieFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableMovies ORDER BY $orderBy');

    final result = await db.query(tableMovies, orderBy: orderBy);

    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;

    return db.update(
      tableMovies,
      movie.toJson(),
      where: '${MovieFields.id} = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMovies,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
