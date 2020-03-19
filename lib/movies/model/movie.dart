import 'package:android_lab/movies/adapter/database.dart';

class Movie {
  int id;
  String name;
  String overview;
  num rating;
  int year;
  String countries;
  bool watched;
  bool planned;
  String posterPath;

  String getShortName() {
    if (name.length > 20) {
      return name.substring(0, 19) + "...";
    } else {
      return name;
    }
  }

  Movie(
      {this.id,
      this.name,
      this.overview = "",
      // ignore: avoid_init_to_null
      this.year = null,
      this.rating,
      this.countries,
      // ignore: avoid_init_to_null
      this.posterPath = null,
      this.watched = false,
      this.planned = false});

  factory Movie.fromJson(Map<String, dynamic> json) {
    var year;
    if (json.containsKey("release_date")) {
      try {
        var releaseDate = DateTime.parse(json["release_date"] as String);
        year = releaseDate.year;
      } on Exception catch (_) {
        print("$_");
      }
    }
    String countries;
    if (json.containsKey("production_countries") &&
        json["production_countries"] != null) {
      Iterable<dynamic> productionCountries =
          json["production_countries"] as Iterable<dynamic>;
      if (productionCountries.isNotEmpty) {
        Iterable<String> filtered = productionCountries
            .where((pc) => pc.containsKey("name"))
            .map((pc) => pc["name"] as String);
        if (filtered != null) {
          countries =
              filtered.reduce((value, element) => value + "," + element);
        }
      }
    }
    print("${json["poster_path"]}");
    return Movie(
        id: json["id"] as int,
        name: json["title"] as String,
        overview: json["overview"] as String,
        year: year,
        rating: json["vote_average"] as num,
        countries: countries,
        posterPath: json["poster_path"]);
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.id: id,
      DatabaseHelper.name: name,
      DatabaseHelper.overview: overview,
      DatabaseHelper.rating: rating,
      DatabaseHelper.year: year,
      DatabaseHelper.countries: countries,
      DatabaseHelper.watched: watched,
      DatabaseHelper.planned: planned,
      DatabaseHelper.posterPath: posterPath
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    print("$map");
    return Movie(
        id: map[DatabaseHelper.id],
        name: map[DatabaseHelper.name],
        overview: map[DatabaseHelper.overview],
        rating: map[DatabaseHelper.rating],
        year: map[DatabaseHelper.year],
        countries: map[DatabaseHelper.countries],
        watched: intToBool(map[DatabaseHelper.watched]),
        planned: intToBool(map[DatabaseHelper.planned]),
        posterPath: map[DatabaseHelper.posterPath]);
  }

  static bool intToBool(int i) {
    return i != 0;
  }

  @override
  String toString() {
    return 'Movie{name: $name, rating: $rating, countries: $countries, year: $year}';
  }
}
