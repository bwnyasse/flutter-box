import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'oloodi_data.dart';
import 'oloodi_utils.dart' as service_utils;

const String api = "http://vmi92598.contabo.host:8080/api/public";

/////////////////////////
/////////// FORMATIONS //
////////////////////////

Future<FormationSearchResponse> searchFormation(
    {String pageNumber = "1", Map searchQuery}) async {
  Completer<FormationSearchResponse> completer = new Completer<
      FormationSearchResponse>();

  Map queryParams = new Map();
  if (searchQuery != null) {
    queryParams.addAll(searchQuery);
  }
  queryParams["p"] = pageNumber.toString();

  String url = service_utils.toUrl([api, "search", "formation"]);
  debugPrint(url.toString());
  http.Response response = await _get(
      url: url +
          service_utils.encodeMapQueryParametersAsUrl(queryParams));

  Map json = JSON.decode(response.body);
  debugPrint(json.toString());
  FormationSearchResponse result = new FormationSearchResponse.fromJson(
      json);
  completer.complete(result);

  return completer.future;
}

///
/// Appel d'une [url] en 'GET'
///
Future<http.Response> _get({String url,
  bool asAcceptHeaderJson: false,
  bool asContentTypeHeadersAsFormUrlEncoded: false,
  bool asContentTypeHeaderJson: true,
  bool secure: false}) async =>
    _performServerCall(url,
        method: 'GET',
        asAcceptHeaderJson: asAcceptHeaderJson,
        asContentTypeHeaderJson: asContentTypeHeaderJson,
        secure: secure);

Future<http.Response> _performServerCall(String url,
    {var sendData: null,
      String method: 'POST',
      bool asAcceptHeaderJson: false,
      bool asContentTypeHeadersAsFormUrlEncoded: false,
      bool asContentTypeHeaderJson: true,
      bool secure: false}) {
  Map<String, String> requestHeaders = {};
  if (asAcceptHeaderJson) {
    requestHeaders.addAll(_addAcceptHeadersAsJson());
  }
  if (asContentTypeHeaderJson) {
    requestHeaders.addAll(_addContentTypeHeadersAsJson(secure));
  }

  if (asContentTypeHeadersAsFormUrlEncoded) {
    requestHeaders.addAll(_addContentTypeHeadersAsFormUrlEncoded());
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

Map<String, String> _addContentTypeHeadersAsJson(bool secure) {
  Map map = new Map();
  map['Content-Type'] = 'application/json';
  if (secure) {
    //TODO
  }
  return map;
}

Map<String, String> _addContentTypeHeadersAsFormUrlEncoded() =>
    {'Content-Type': 'application/x-www-form-urlencoded'};