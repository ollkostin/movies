import 'package:android_lab/movies/model/movie.dart';

import 'database.dart';

class MovieService {
  MovieService(this.db);

  final AbstractDatabaseHelper db;

  Future<Movie> find(int id) => db.find(id);

  Future<List<Movie>> getPlannedMovies() => db.getPlannedMovies();

  Future<List<Movie>> getWatchedMovies() => db.getWatchedMovies();

  Future<int> processMovie(Movie movie) async {
    if (!movie.watched && !movie.planned) {
      return db.remove(movie);
    } else {
      return db.save(movie);
    }
  }
}
