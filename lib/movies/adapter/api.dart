import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:android_lab/movies/model/movie.dart';

class Api {
  final apiKey = '036d482440ec948860f458dd4d128c8b';

  static final imagesUrl = "https://image.tmdb.org/t/p/";

  static final bigPoster = "$imagesUrl" + "w154";

  static final smallPoster = "$imagesUrl" + "w45";

  String getBigPosterUrl(String path) => "$imagesUrl" + "w154" + path;

  String getSmallPosterUrl(String path) => "$imagesUrl" + "w45" + path;

  String queryUrl(String text) =>
      "https://api.themoviedb.org/3/search/movie/?api_key=$apiKey&query=$text";

  String movieUrl(int id) =>
      "https://api.themoviedb.org/3/movie/$id?api_key=$apiKey";

  Future<List<Movie>> fetchMoviesAsync(String text) async {
    var response = http.get(queryUrl(text));
    return response.then((http.Response value) {
      List<Movie> movies = [];
      if (value.statusCode == 200) {
        Map<String, Object> res = json.decode(value.body);
        List<dynamic> results = res["results"];
        print(res);
        movies = results.map((jsonObject) {
          return Movie.fromJson(jsonObject);
        }).toList();
      }
      print(movies);
      return movies;
    });
  }

  Future<Movie> fetchMovieAsync(int id) async {
    var response = http.get(movieUrl(id));

    return response.then((http.Response value) {
      if (value.statusCode == 200) {
        Map<String, Object> res = json.decode(value.body);
        return Movie.fromJson(res);
      }
      throw Exception("Can not fetch movie with id $id");
    });
  }
}
