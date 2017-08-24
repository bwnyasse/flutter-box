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

import 'dart:async';
import 'package:flutter/material.dart';
import 'moviedb_datamodel.dart';
import 'moviedb_http.dart' as moviedb_http;

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;
  List<SearchMovieEntry> _entries = [];

   onSearchQueryValueChange(String newValue) async {
    SearchMoviesResponse response = await moviedb_http.searchMovie(newValue);
    setState((){
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

  Widget _buildAppBar() {
    return new AppBar(
      elevation: 0.0,
      title: new Text("DevFest MovieDB Demo"),
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearchBegin,
          tooltip: 'Search',
        ),
      ],
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
      body: new Container(
        child: new SearchMovieList(_entries),
      ),
    );
  }
}

class SearchMovieList extends StatefulWidget {
  List<SearchMovieEntry> _entries = [];

  SearchMovieList(this._entries);

  @override
  _SearchMovieListState createState() => new _SearchMovieListState();
}

class _SearchMovieListState extends State<SearchMovieList> {

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: const ValueKey<String>('movieentry-list'),
      itemCount: widget._entries.length,
      itemBuilder: (BuildContext context, int index) {
        return new SearchMovieListRow(
          entry: widget._entries[index],
        );
      },
    );
  }
}

class SearchMovieListRow extends StatelessWidget {

  SearchMovieListRow({
    this.entry,
  }) : super(key: new ObjectKey(entry));

  final SearchMovieEntry entry;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        child: new Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(color: Theme
                        .of(context)
                        .dividerColor)
                )
            ),
            child: new Row(
                children: <Widget>[

                  new Expanded(
                      child: new Row(
                          children: <Widget>[
                            new Expanded(
                                flex: 2,
                                child: new Text(
                                    entry.originalTitle
                                )
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: DefaultTextStyle
                              .of(context)
                              .style
                              .textBaseline
                      )
                  ),
                ]
            )
        )
    );
  }
}