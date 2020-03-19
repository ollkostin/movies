import 'package:flutter/material.dart';
import 'movies/ui/home_page.dart';

void main() {
  runApp(WhatToWatch());
}

class WhatToWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatToWatch',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: WhatToWatchHomePage(),
    );
  }
}
