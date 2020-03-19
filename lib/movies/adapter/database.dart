import 'package:android_lab/movies/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class AbstractDatabaseHelper {
  Future<Database> get database;

  Future<int> remove(Movie movie);

  Future<int> save(Movie movie);

  Future<List<Movie>> getMovies();

  Future<List<Movie>> getPlannedMovies();

  Future<List<Movie>> getWatchedMovies();

  Future<Movie> find(int id);
}

class DatabaseHelper extends AbstractDatabaseHelper {
  static final id = "id";
  static final name = "name";
  static final overview = "overview";
  static final rating = "rating";
  static final countries = "countries";
  static final watched = "watched";
  static final planned = "planned";
  static final posterPath = "poster_path";
  static final year = "year";
  static final movies = "movies";

  static Database _database;

  @override
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    final path = await getDatabasesPath();
    var db =
        openDatabase(join(path, 'movies.db'), version: 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE movies( 
        $id INTEGER PRIMARY KEY,
        $name TEXT,
        $overview TEXT,
        $rating NUMERIC,
        $countries TEXT,
        $year INTEGER,
        $watched BOOLEAN,
        $planned BOOLEAN,
        $posterPath TEXT
        );
        ''');
  }

  @override
  Future<int> remove(Movie movie) async {
    final db = await database;

    final id = movie.id;

    int affectedRows = await db.delete(DatabaseHelper.movies,
        where: "${DatabaseHelper.id} = ?", whereArgs: [id]);

    if (affectedRows == 0) {
      print("Nothing happened");
    }
    return Future.value(affectedRows);
  }

  @override
  Future<int> save(Movie movie) async {
    final db = await database;

    int affectedRows = await db.insert(
      movies,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (affectedRows == 0) {
      print("Nothing happened");
    }
    return Future.value(affectedRows);
  }

  @override
  Future<List<Movie>> getMovies() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(movies);

    return maps.map((m) => Movie.fromMap(m)).toList();
  }

  @override
  Future<List<Movie>> getPlannedMovies() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(movies, where: "$planned = ?", whereArgs: [1]);

    return maps.map((m) => Movie.fromMap(m)).toList();
  }

  @override
  Future<List<Movie>> getWatchedMovies() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(movies, where: "$watched = ?", whereArgs: [1]);

    return maps.map((m) => Movie.fromMap(m)).toList();
  }

  @override
  Future<Movie> find(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db
        .query(movies, where: "${DatabaseHelper.id} = ?", whereArgs: [id]);
    if (result.isEmpty) {
      return Future.value(null);
    }
    return Movie.fromMap(result[0]);
  }
}
