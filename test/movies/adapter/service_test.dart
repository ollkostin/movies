import 'dart:convert';

import 'package:android_lab/movies/adapter/database.dart';
import 'package:android_lab/movies/adapter/service.dart';
import 'package:android_lab/movies/model/movie.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDatabaseHelper extends Mock implements AbstractDatabaseHelper {}

void main() {
  final mockDb = MockDatabaseHelper();
  final service = MovieService(mockDb);

  final movieJson = json.decode('''
  {
   "poster_path":"\/zwgPO5bamUuajIAEc02q9XZ2qhq.jpg",
   "id":529485,
   "backdrop_path":"\/5mubFanEHVFJff4jLQH0uIOThMz.jpg",
   "original_title":"The Way Back",
   "title":"The Way Back",
   "vote_average":6.5,
   "overview":"A former basketball all-star, who has lost his wife and family foundation in a struggle with addiction attempts to regain his soul and salvation by becoming the coach of a disparate ethnically mixed high school basketball team at his alma mater.",
   "release_date":"2020-03-05"
}''');

  group('by id', () {
    test('When movie exists then return movie', () async {
      var movie = Movie.fromJson(movieJson);
      var future = Future.value(movie);
      when(mockDb.find(1)).thenAnswer((_) => future);

      expect(await service.find(1), movie);
    });

    test('when no movie then return null', () async {
      when(mockDb.find(1)).thenAnswer((_) => Future.value(null));

      expect(await service.find(1), null);
    });
  });

  group('search', () {
    test('when search for watched then return only watched', () async {
      List<Movie> watched = [Movie.fromJson(movieJson)];

      when(mockDb.getWatchedMovies()).thenAnswer((_) => Future.value(watched));

      expect(await service.getWatchedMovies(), watched);
    });

    test('when search for planned then return only planned', () async {
      List<Movie> planned = [Movie.fromJson(movieJson)];

      when(mockDb.getPlannedMovies()).thenAnswer((_) => Future.value(planned));

      expect(await service.getPlannedMovies(), planned);
    });
  });

  group('processing', () {
    test('when movie is planned then save', () async {
      var movie = Movie.fromJson(movieJson);
      movie.planned = true;
      when(mockDb.save(movie)).thenAnswer((_) => Future.value(1));

      expect(await service.processMovie(movie), 1);
      verify(mockDb.save(movie));
    });

    test('when movie is watched then save', () async {
      var movie = Movie.fromJson(movieJson);
      movie.watched = true;
      when(mockDb.save(movie)).thenAnswer((_) => Future.value(1));

      expect(await service.processMovie(movie), 1);
      verify(mockDb.save(movie));
    });

    test('when movie is not watched and not planned then remove', () async {
      var movie = Movie.fromJson(movieJson);

      when(mockDb.remove(movie)).thenAnswer((_) => Future.value(1));

      expect(await service.processMovie(movie), 1);
      verify(mockDb.remove(movie));
    });
  });
}
