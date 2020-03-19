import 'package:android_lab/movies/adapter/holder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieDetailsCard extends StatefulWidget {
  const MovieDetailsCard({Key key, @required this.movie}) : super(key: key);

  final Movie movie;

  @override
  _MovieDetailsCardState createState() => _MovieDetailsCardState();
}

class _MovieDetailsCardState extends State<MovieDetailsCard> {
  final service = Holder.service;
  final api = Holder.api;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.movie.name)),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_buildImage(), _buildInfo()],
          ),
          Divider(color: Colors.transparent),
          _buildOverviewWidget()
        ]));
  }

  Widget _buildOverviewWidget() {
    if (widget.movie.overview.isNotEmpty) {
      return Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Overview:",
                    textScaleFactor: 2,
                  ))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                widget.movie.overview,
                softWrap: true,
                style: TextStyle(fontSize: 15),
              )),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildInfo() {
    List<Widget> list = [_buildNameLabel()];
    if (widget.movie.year != null) {
      list.add(_buildYearLabel());
    }
    if (widget.movie.countries != null) {
      list.add(_buildCountriesLabel());
    }
    list.add(_buildRatingLabel());
    list.add(_buildAddToWatchListButton());
    list.add(_buildAlreadyWatchedButton());
    return Column(children: list);
  }

  Widget _buildNameLabel() {
    return Container(
        child: Text("${widget.movie.name}", textAlign: TextAlign.left));
  }

  Widget _buildYearLabel() {
    return Container(
        child: Text("${widget.movie.year}", textAlign: TextAlign.left));
  }

  Widget _buildCountriesLabel() {
    String countries = widget.movie.countries;
    List<String> list = countries.split(",");
    List<Widget> result =
        list.map((s) => Text("$s", textAlign: TextAlign.left)).toList();
    return Column(children: result);
  }

  Widget _buildRatingLabel() {
    return Container(child: Text("${widget.movie.rating}"));
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      placeholder: (context, url) => CircularProgressIndicator(),
      imageUrl: api.getBigPosterUrl(widget.movie.posterPath),
    );
  }

  Widget _buildAlreadyWatchedButton() {
    if (widget.movie.watched) {
      return FlatButton(
        child: Text("Delete from watched"),
        color: Colors.black,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(),
        onPressed: () {
          final forSave = widget.movie;
          forSave.watched = false;
          _updateMovieInfo(forSave, (movie) {
            widget.movie.watched = movie.watched;
          });
        },
      );
    } else {
      return FlatButton(
        child: Text("Add to watched"),
        color: Colors.white,
        textColor: Colors.black,
        shape: RoundedRectangleBorder(),
        onPressed: () {
          final forSave = widget.movie;
          forSave.watched = true;
          _updateMovieInfo(forSave, (movie) {
            widget.movie.watched = movie.watched;
          });
        },
      );
    }
  }

  void _updateMovieInfo(Movie movie, Function(Movie movie) updateState) {
    service.processMovie(movie).then((affectedRows) {
      if (affectedRows != 0) {
        setState(() {
          updateState(movie);
        });
      }
    });
  }

  Widget _buildAddToWatchListButton() {
    if (widget.movie.planned) {
      return FlatButton(
        child: Text("Remove from planned"),
        color: Colors.black,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(),
        onPressed: () {
          final forSave = widget.movie;
          forSave.planned = false;
          _updateMovieInfo(forSave, (movie) {
            widget.movie.planned = movie.planned;
          });
        },
      );
    } else {
      return FlatButton(
        child: Text("Add to planned"),
        color: Colors.white,
        textColor: Colors.black,
        shape: RoundedRectangleBorder(),
        onPressed: () {
          final forSave = widget.movie;
          forSave.planned = true;
          _updateMovieInfo(forSave, (movie) {
            widget.movie.planned = movie.planned;
          });
        },
      );
    }
  }
}
