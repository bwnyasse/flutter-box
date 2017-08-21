library oloodi;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show
debugPaintSizeEnabled,
debugPaintBaselinesEnabled,
debugPaintLayerBordersEnabled,
debugPaintPointersEnabled,
debugRepaintRainbowEnabled;

import 'oloodi_types.dart';
import 'oloodi_data.dart';
import 'oloodi_home.dart';
import 'package:flutter/foundation.dart';
import 'oloodi_http.dart' as oloodi_http;

Route<Null> _getRoute(RouteSettings settings) {
  // Routes, by convention, are split on slashes, like filesystem paths.
  final List<String> path = settings.name.split('/');
  // We only support paths that start with a slash, so bail if
  // the first component is not empty:
  if (path[0] != '')
    return null;
/*  // If the path is "/stock:..." then show a stock page for the
  // specified stock symbol.
  if (path[1].startsWith('stock:')) {
    // We don't yet support subpages of a stock, so bail if there's
    // any more path components.
    if (path.length != 2)
      return null;
    // Extract the symbol part of "stock:..." and return a route
    // for that symbol.
    final String symbol = path[1].substring(6);
    return new MaterialPageRoute<Null>(
      settings: settings,
      builder: (BuildContext context) => new StockSymbolPage(symbol: symbol, stocks: stocks),
    );
  }*/
  // The other paths we support are in the routes table.
  return null;
}

Future<LocaleQueryData> _onLocaleChanged(Locale locale) async {
  // TODO
  return null;
}

OloodiConfiguration _getConfiguration() =>
    new OloodiConfiguration(
        oloodiMode: OloodiMode.optimistic,
        backupMode: BackupMode.enabled,
        debugShowGrid: false,
        debugShowSizes: false,
        debugShowBaselines: false,
        debugShowLayers: false,
        debugShowPointers: false,
        debugShowRainbow: false,
        showPerformanceOverlay: false,
        showSemanticsDebugger: false
    );

class OloodiApp extends StatefulWidget {
  @override
  OloodiAppState createState() => new OloodiAppState();
}

class OloodiAppState extends State<OloodiApp> {
  FormationSearchResponse _formationSearchResponse;

  OloodiConfiguration _configuration = _getConfiguration();

  void configurationUpdater(OloodiConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  ThemeData get theme {
    switch (_configuration.oloodiMode) {
      case OloodiMode.optimistic:
        return new ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.purple
        );
      case OloodiMode.pessimistic:
        return new ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.redAccent
        );
    }
    assert(_configuration.oloodiMode != null);
    return null;
  }

  fetchFormation() =>  oloodi_http.searchFormation();

  @override
  Widget build(BuildContext context) {
    assert(() {
      debugPaintSizeEnabled = _configuration.debugShowSizes;
      debugPaintBaselinesEnabled = _configuration.debugShowBaselines;
      debugPaintLayerBordersEnabled = _configuration.debugShowLayers;
      debugPaintPointersEnabled = _configuration.debugShowPointers;
      debugRepaintRainbowEnabled = _configuration.debugShowRainbow;
      return true;
    });
    return new MaterialApp(
        title: 'Oloodi',
        theme: theme,
        debugShowMaterialGrid: _configuration.debugShowGrid,
        showPerformanceOverlay: _configuration.showPerformanceOverlay,
        showSemanticsDebugger: _configuration.showSemanticsDebugger,
        routes: <String, WidgetBuilder>{
          '/':         (BuildContext context) => new FutureBuilder<FormationSearchResponse>(
            future: fetchFormation(), // a Future<FormationSearchResponse> or null
            builder: (BuildContext context, AsyncSnapshot<FormationSearchResponse> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none: return new Text('Press button to start');
                case ConnectionState.waiting: return new Text('Awaiting result...');
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return new OloodiHome(snapshot.data, null, _configuration, configurationUpdater);
              }
            },
          ),
        },
        onGenerateRoute: _getRoute,
        //onLocaleChanged: _onLocaleChanged
    );
  }
}

void main() {
  runApp(new OloodiApp());
}
