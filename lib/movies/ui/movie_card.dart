import 'package:android_lab/movies/adapter/holder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({Key key, @required this.movie}) : super(key: key);

  final Movie movie;

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final api = Holder.api;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 0.1)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildImage(), _buildInfo()]));
  }

  Widget _buildInfo() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Text(this.widget.movie.name,
            style: TextStyle(color: Colors.black, fontSize: 15)),
        Text("${this.widget.movie.rating.toString()}",
            style: TextStyle(color: Colors.black, fontSize: 15))
      ]);

  Widget _buildImage() => CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(),
        imageUrl: api.getSmallPosterUrl(this.widget.movie.posterPath),
      );
}
