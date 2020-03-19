import 'package:android_lab/movies/adapter/holder.dart';
import 'package:android_lab/movies/ui/movie_details_card.dart';
import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieSearchCard extends StatefulWidget {
  const MovieSearchCard({Key key, @required this.movie}) : super(key: key);

  final Movie movie;

  @override
  _MovieSearchCardState createState() => _MovieSearchCardState();
}

class _MovieSearchCardState extends State<MovieSearchCard> {
  final service = Holder.service;
  final api = Holder.api;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "${widget.movie.getShortName()} (${widget.movie.year})",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.left,
          softWrap: true,
        ),
        VerticalDivider(
          color: Colors.transparent,
        ),
        IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              var fromDb = service.find(widget.movie.id);
              fromDb.then((found) => process(found));
            })
      ],
    );
  }

  void process(Movie found) {
    if (found == null) {
      api
          .fetchMovieAsync(widget.movie.id)
          .then((_) => _showMovieDetails(_))
          .catchError((err) => print(err.toString()));
    } else {
      _showMovieDetails(found);
    }
  }

  void _showMovieDetails(Movie movie) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => MovieDetailsCard(movie: movie)));
}
