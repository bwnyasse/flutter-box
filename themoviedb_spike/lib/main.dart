import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show
debugPaintSizeEnabled,
debugPaintBaselinesEnabled,
debugPaintLayerBordersEnabled,
debugPaintPointersEnabled,
debugRepaintRainbowEnabled;
import 'moviedb_home.dart';
import 'moviedb_tab.dart';
import 'moviedb_settings.dart';

void main() {
  runApp(new MyApp());
}

Route<Null> _getRoute(RouteSettings settings) {
  // Routes, by convention, are split on slashes, like filesystem paths.
  final List<String> path = settings.name.split('/');
  // We only support paths that start with a slash, so bail if
  // the first component is not empty:
  if (path[0] != '')
    return null;

  // The other paths we support are in the routes table.
  return null;
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {

  AppConfiguration _configuration = new AppConfiguration(
      appMode: AppMode.optimistic,
      debugShowGrid: false,
      debugShowSizes: false,
      debugShowBaselines: false,
      debugShowLayers: false,
      debugShowPointers: false,
      debugShowRainbow: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false
  );

  void configurationUpdater(AppConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  ThemeData get theme {
    switch (_configuration.appMode) {
      case AppMode.optimistic:
        return new ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue
        );
      case AppMode.pessimistic:
        return new ThemeData(
            brightness: Brightness.dark,
            accentColor: Colors.blueAccent
        );
    }
    assert(_configuration.appMode != null);
    return null;
  }

  // This widget is the root of your application.
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
/*      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Hot Reload App in IntelliJ). Notice that the counter
        // didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),*/
      theme: theme,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new MyHomePage(),
        '/discover': (BuildContext context) => new MoviesTabs(),
        '/settings':  (BuildContext context) => new AppSettings(_configuration, configurationUpdater),
      },
      onGenerateRoute: _getRoute,
    );
  }
}
