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

const String API = "https://api.themoviedb.org/3/";


Future<SearchMoviesResponse> searchMovie([String query]) async {
  Completer<SearchMoviesResponse> completer = new Completer<
      SearchMoviesResponse>();

  http.Response response = await _get(
      url: "https://api.themoviedb.org/3/search/movie?api_key=4205ec1d93b1e3465f636f0956a98c64&query=$query");

  Map json = JSON.decode(response.body);
  SearchMoviesResponse result = new SearchMoviesResponse.fromJson(json);
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
