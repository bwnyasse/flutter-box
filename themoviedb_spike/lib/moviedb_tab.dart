/**
 * Copyright (c) 2017 flutter_box. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 31/08/17
 * Author     : bwnyasse
 *
 */

import 'package:flutter/material.dart';
import 'moviedb_datamodel.dart';
import 'moviedb_http.dart' as moviedb_http;

// Each TabBarView contains a _Page and for each _Page there is a list
// of _CardData objects. Each _CardData object is displayed by a _CardItem.

class _Page {
  _Page({ this.label });

  final String label;

  String get id => label;
}

class _MovieDataItem extends StatelessWidget {
  const _MovieDataItem({ this.page, this.data });

  static final double height = 272.0;
  final _Page page;
  final MovieEntry data;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              width: 144.0,
              height: 144.0,
              child: new Image.network(
                "http://image.tmdb.org/t/p/w185//" + data.backdropPath,
                fit: BoxFit.contain,
              ),
            ),
            new Center(
              child: new Text(data.title, style: Theme
                  .of(context)
                  .textTheme
                  .title),
            )
          ],
        ),
      ),
    );
  }
}


class MoviesTabs extends StatefulWidget {
  @override
  _MoviesTabsState createState() => new _MoviesTabsState();
}

class _MoviesTabsState extends State<MoviesTabs> {

  Map<_Page, List<MovieEntry>> _allPages = new Map();

  @override
  void initState() {
    super.initState();
    fetchDiscoverMovies();
  }

  fetchDiscoverMovies() async {
    MoviesResponse popularMovies = await moviedb_http.popuplarMovies();
    MoviesResponse topRatedMovies = await moviedb_http.topRatedMovies();
    MoviesResponse upComingMovies = await moviedb_http.upComingMovies();

    setState(() {
      _allPages = <_Page, List<MovieEntry>>{
        new _Page(label: 'P'): popularMovies.searchMovieEntries,
        new _Page(label: 'T'): topRatedMovies.searchMovieEntries,
        new _Page(label: 'U'): upComingMovies.searchMovieEntries,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return new TabControler(_allPages);
  }
}

class TabControler extends StatefulWidget {
  Map<_Page, List<MovieEntry>> _allPages = new Map();

  TabControler(this._allPages);

  @override
  TabControlerState createState() => new TabControlerState();
}

class TabControlerState extends State<TabControler> {

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: const Text('Discover Movies'),
                pinned: true,
                expandedHeight: 150.0,
                forceElevated: innerBoxIsScrolled,
                bottom: new TabBar(
                  tabs: [
                    new Tab(text: "POPULAR"),
                    new Tab(text: "TOP RATED"),
                    new Tab(text: "UPCOMING"),
                  ],
                ),
              ),
            ];
          },
          body: widget._allPages.isEmpty ?
          new Center(
              child: new Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: new CircularProgressIndicator()
              )
          ) : new TabBarView(
            children: widget._allPages.keys.map((_Page page) {
              return new ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                itemExtent: _MovieDataItem.height,
                children: widget._allPages[page].map((MovieEntry data) {
                  return new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new _MovieDataItem(page: page, data: data),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
