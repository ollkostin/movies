import 'package:android_lab/movies/adapter/holder.dart';
import 'package:android_lab/movies/adapter/service.dart';
import 'package:android_lab/movies/ui/search_controller.dart';
import 'package:flutter/material.dart';
import 'movie_list_widget.dart';

class WhatToWatchHomePage extends StatefulWidget {
  @override
  WhatToWatchHomePageState createState() => WhatToWatchHomePageState();
}

class WhatToWatchHomePageState extends State<WhatToWatchHomePage> {
  final service = Holder.service;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('WhatToWatch'),
          leading: SearchButton(),
          bottom: TabBar(tabs: [Tab(text: "Planned"), Tab(text: "Seen")]),
        ),
        body: TabBarView(children: [
          MovieListWidget(future: service.getPlannedMovies()),
          MovieListWidget(future: service.getWatchedMovies()),
        ]),
      ),
    );
  }
}
