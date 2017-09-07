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
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'moviedb_datamodel.dart';

const String API_KEY = '4205ec1d93b1e3465f636f0956a98c64';

const String API = "https://api.themoviedb.org/3/";

Future<MoviesResponse> popuplarMovies() => _fetchMovie("/movie/popular");

Future<MoviesResponse> topRatedMovies() => _fetchMovie("/movie/top_rated");

Future<MoviesResponse> upComingMovies() => _fetchMovie("/movie/upcoming");

Future<MoviesResponse> discoverMovie() => _fetchMovie("/discover/movie");

Future<MoviesResponse> _fetchMovie(String path) async {
  final http.Response response = await _get(
      url: "https://api.themoviedb.org/3$path?api_key=$API_KEY");

  Map json = JSON.decode(response.body);

  return new MoviesResponse.fromJson(json);
}

Future<MoviesResponse> searchMovie([String query]) async {
  Completer<MoviesResponse> completer = new Completer<
      MoviesResponse>();

  http.Response response = await _get(
      url: "https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&query=$query");

  Map json = JSON.decode(response.body);
  MoviesResponse result = new MoviesResponse.fromJson(json);
  completer.complete(result);

  return completer.future;
}

///
/// Appel d'une [url] en 'GET'
///
Future<http.Response> _get({String url,
  bool asAcceptHeaderJson: false,
  bool asContentTypeHeadersAsFormUrlEncoded: false,
  bool asContentTypeHeaderJson: true
}) async =>
    _performServerCall(url,
        method: 'GET',
        asAcceptHeaderJson: asAcceptHeaderJson,
        asContentTypeHeaderJson: asContentTypeHeaderJson);

Future<http.Response> _performServerCall(String url,
    {var sendData: null,
      String method: 'POST',
      bool asAcceptHeaderJson: false,
      bool asContentTypeHeadersAsFormUrlEncoded: false,
      bool asContentTypeHeaderJson: true}) {
  Map<String, String> requestHeaders = {};
  if (asAcceptHeaderJson) {
    requestHeaders.addAll(_addAcceptHeadersAsJson());
  }
  if (asContentTypeHeaderJson) {
    requestHeaders.addAll(_addContentTypeHeadersAsJson());
  }

  switch (method) {
    case 'GET':
      return http.get(url, headers: requestHeaders);
      break;
    default:
      break;
  }

  return null;
}

Map<String, String> _addAcceptHeadersAsJson() =>
    {'Accept': 'application/json'};

Map<String, String> _addContentTypeHeadersAsJson() =>
    {'Content-Type': 'application/json'};
