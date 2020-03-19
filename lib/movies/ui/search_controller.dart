import 'dart:async';
import 'package:flutter/material.dart';
import 'package:android_lab/movies/adapter/holder.dart';
import 'package:android_lab/movies/model/movie.dart';
import 'package:android_lab/movies/ui/movie_search_card.dart';

class SearchButton extends GestureDetector {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => SearchController())),
        child: Icon(Icons.search));
  }
}

class SearchController extends StatefulWidget {
  @override
  _SearchControllerState createState() => _SearchControllerState();
}

class _SearchControllerState extends State<SearchController> {
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error;
  Timer debounceTimer;
  List<Movie> _results = [];

  final api = Holder.api;

  _SearchControllerState() {
    _searchQuery.addListener(() {
      if (debounceTimer != null) {
        debounceTimer.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 500), () {
        if (this.mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.length < 3) {
      setState(() {
        _isSearching = false;
        _error = null;
        _results = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _results = List();
    });

    api
        .fetchMoviesAsync(query)
        .then((res) => onFinishSearch(res))
        .catchError((error) => print("Error $error"));
  }

  void onFinishSearch(List<Movie> res) {
    var isMounted = this.mounted;
    var notEmpty = this._searchQuery.text.length >= 3;
    if (notEmpty && isMounted) {
      setState(() {
        _isSearching = false;
        if (res != null) {
          _results = res;
        } else {
          _error = 'Error searching res';
        }
      });
    }
  }

  void updateResult(movies) {
    setState(() {
      _isSearching = false;
      _results = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
          child: TextField(
            autofocus: true,
            enableSuggestions: false,
            controller: _searchQuery,
            onChanged: (text) {
              _isSearching = true;
              performSearch(text);
            },
            decoration: buildInputDecoration(),
          ),
        )),
        body: buildBody(context));
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(end: 16.0),
            child: Icon(
              Icons.search,
              color: Colors.white,
            )),
        hintText: "Search movies",
        hintStyle: TextStyle(color: Colors.white));
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      return CenterTitle('Searching movies');
    } else if (_error != null) {
      return CenterTitle(_error);
    } else if (_searchQuery.text.length < 3) {
      return CenterTitle('Start search by typing on search bar');
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) =>
              MovieSearchCard(movie: _results[index]));
    }
  }
}

class CenterTitle extends StatelessWidget {
  final String title;

  CenterTitle(this.title);

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      alignment: Alignment.center,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
        textAlign: TextAlign.center,
      ));
}
