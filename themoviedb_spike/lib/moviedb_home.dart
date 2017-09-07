/**
 * Copyright (c) 2017 flutter_box. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 24/08/17
 * Author     : bwnyasse
 *
 */

import 'package:flutter/material.dart';
import 'moviedb_datamodel.dart';
import 'moviedb_settings.dart';
import 'moviedb_http.dart' as moviedb_http;

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;
  List<MovieEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    discoverMovie();
  }

  discoverMovie() async {
    MoviesResponse response = await moviedb_http.discoverMovie();
    setState(() {
      _entries = response.searchMovieEntries;
    });
  }

  onSearchQueryValueChange(String newValue) async {
    MoviesResponse response = await moviedb_http.searchMovie(newValue);
    setState(() {
      _entries = response.searchMovieEntries;
    });
  }

  void _handleSearchBegin() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(
      onRemove: () {
        setState(() {
          _isSearching = false;
          _searchQuery.clear();
        });
      },
    ));
    setState(() {
      _isSearching = true;
    });
  }

  void _handleShowDiscover(){
    Navigator.popAndPushNamed(context, '/discover');
  }

  void _handleShowSettings(){
    Navigator.popAndPushNamed(context, '/settings');
  }


  Widget _buildAppBar() {
    return new AppBar(
      elevation: 0.0,
      title: new Text("DevFest Toulouse - Movies App"),
/*      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearchBegin,
          tooltip: 'Search',
        ),
      ],*/
    );
  }

  Widget _buildSearchBar() {
    return new AppBar(
      leading: new BackButton(
        color: Theme
            .of(context)
            .accentColor,
      ),
      title: new TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search a movie',
        ),
        onSubmitted: onSearchQueryValueChange,
      ),
      backgroundColor: Theme
          .of(context)
          .canvasColor,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          const DrawerHeader(child: const Center(child: const Text('Devfest Movie App'))),
          const ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Home'),
            selected: true,
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Discover'),
            onTap: _handleShowDiscover,
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: _handleShowSettings,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: _isSearching ? _buildSearchBar() : _buildAppBar(),
      drawer: _buildDrawer(context),
      body: new Container(
        child: new MoviesList(_entries),
      ),
    );
  }
}

class MoviesList extends StatefulWidget {
  List<MovieEntry> _entries = [];

  MoviesList(this._entries);

  @override
  MovieListState createState() => new MovieListState();
}

class MovieListState extends State<MoviesList> {

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: const ValueKey<String>('movieentry-list'),
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      itemCount: widget._entries.length,
      itemBuilder: (BuildContext context, int index) {
        return new MovieListRow(
          entry: widget._entries[index],
        );
      },
    );
  }
}

class MovieListRow extends StatelessWidget {

  MovieListRow({
    this.entry,
  }) : super(key: new ObjectKey(entry));

  final MovieEntry entry;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        child: new Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(color: Theme
                        .of(context)
                        .dividerColor)
                )
            ),
            child: _buildCard(context, entry)
        )
    );
  }

  Widget _buildCard(BuildContext context, MovieEntry entry) {
    final double height = 366.0;
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(
        color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return new Container(
      padding: const EdgeInsets.all(8.0),
      height: height,
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // photo and title
            new SizedBox(
              height: 184.0,
              child: new Stack(
                children: <Widget>[
                  new Positioned.fill(
                    child: new Image.network(
                      "http://image.tmdb.org/t/p/w185//" + entry.backdropPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  new Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: new FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: FractionalOffset.centerLeft,
                      child: new Text(entry.originalTitle,
                        style: titleStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // description and share/expore buttons
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: new DefaultTextStyle(
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: descriptionStyle,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // three line description
                      new Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          entry.overview,
                          style: descriptionStyle.copyWith(
                              color: Colors.black54),
                        ),
                      ),
                      new Text(entry.originalLanguage),
                      new Text(entry.releaseDate),
                    ],
                  ),
                ),
              ),
            ),
            // share, explore buttons
            new ButtonTheme.bar(
              child: new ButtonBar(
                alignment: MainAxisAlignment.start,
                children: <Widget>[
                  new FlatButton(
                    child: const Text('SHARE'),
                    textColor: Colors.amber.shade500,
                    onPressed: () {
                      /* do nothing */
                    },
                  ),
                  new FlatButton(
                    child: const Text('EXPLORE'),
                    textColor: Colors.amber.shade500,
                    onPressed: () {
                      /* do nothing */
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}