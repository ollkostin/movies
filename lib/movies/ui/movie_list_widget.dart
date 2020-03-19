import 'package:android_lab/movies/ui/movie_card.dart';
import 'package:flutter/material.dart';

import '../model/movie.dart';
import 'movie_details_card.dart';

class MovieListWidget extends StatefulWidget {
  final Future<List<Movie>> future;

  MovieListWidget({Key key, @required this.future}) : super(key: key);

  @override
  MovieListWidgetState createState() => MovieListWidgetState();
}

class MovieListWidgetState extends State<MovieListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.fromFuture(widget.future),
      builder: (context, snapshot) {
        print("has data : ${snapshot.hasData}");
        print("state : ${snapshot.connectionState}");
        return snapshot.hasData
            ? _buildGrid(snapshot, context)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  GridView _buildGrid(AsyncSnapshot snapshot, BuildContext context) {
    final movies = snapshot.data as List<Movie>;
    print("build grid for movies. size = ${movies.length}");
    return GridView.builder(
        primary: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: movies.length,
        itemBuilder: (ctx, index) {
          return _buildMovieCard(context, movies[index]);
        });
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
    print("build card");
    return Card(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => MovieDetailsCard(movie: movie)))
                  .then((v) {
                this.setState(() {});
              });
            },
            child: MovieCard(movie: movie)));
  }
}
