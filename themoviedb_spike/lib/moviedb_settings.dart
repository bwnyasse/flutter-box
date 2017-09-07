/**
 * Copyright (c) 2017 flutter_box. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 01/09/17
 * Author     : bwnyasse
 *  
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppMode { optimistic, pessimistic }

class AppConfiguration {
  AppConfiguration({
    @required this.appMode,
    @required this.debugShowGrid,
    @required this.debugShowSizes,
    @required this.debugShowBaselines,
    @required this.debugShowLayers,
    @required this.debugShowPointers,
    @required this.debugShowRainbow,
    @required this.showPerformanceOverlay,
    @required this.showSemanticsDebugger
  }) : assert(appMode != null),
        assert(debugShowGrid != null),
        assert(debugShowSizes != null),
        assert(debugShowBaselines != null),
        assert(debugShowLayers != null),
        assert(debugShowPointers != null),
        assert(debugShowRainbow != null),
        assert(showPerformanceOverlay != null),
        assert(showSemanticsDebugger != null);

  final AppMode appMode;
  final bool debugShowGrid;
  final bool debugShowSizes;
  final bool debugShowBaselines;
  final bool debugShowLayers;
  final bool debugShowPointers;
  final bool debugShowRainbow;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;

  AppConfiguration copyWith({
    AppMode appMode,
    bool debugShowGrid,
    bool debugShowSizes,
    bool debugShowBaselines,
    bool debugShowLayers,
    bool debugShowPointers,
    bool debugShowRainbow,
    bool showPerformanceOverlay,
    bool showSemanticsDebugger
  }) {
    return new AppConfiguration(
        appMode: appMode ?? this.appMode,
        debugShowGrid: debugShowGrid ?? this.debugShowGrid,
        debugShowSizes: debugShowSizes ?? this.debugShowSizes,
        debugShowBaselines: debugShowBaselines ?? this.debugShowBaselines,
        debugShowLayers: debugShowLayers ?? this.debugShowLayers,
        debugShowPointers: debugShowPointers ?? this.debugShowPointers,
        debugShowRainbow: debugShowRainbow ?? this.debugShowRainbow,
        showPerformanceOverlay: showPerformanceOverlay ?? this.showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger ?? this.showSemanticsDebugger
    );
  }
}

class AppSettings extends StatefulWidget {
  const AppSettings(this.configuration, this.updater);

  final AppConfiguration configuration;
  final ValueChanged<AppConfiguration> updater;

  @override
  AppSettingsState createState() => new AppSettingsState();
}

class AppSettingsState extends State<AppSettings>{

  void _handleOptimismChanged(bool value) {
    value ??= false;
    sendUpdates(widget.configuration.copyWith(appMode: value ? AppMode.optimistic : AppMode.pessimistic));
  }

  void sendUpdates(AppConfiguration value) {
    if (widget.updater != null)
      widget.updater(value);
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        title: const Text('Settings')
    );
  }

  void _confirmOptimismChange() {
    switch (widget.configuration.appMode) {
      case AppMode.optimistic:
        _handleOptimismChanged(false);
        break;
      case AppMode.pessimistic:
        showDialog<bool>(
            context: context,
            child: new AlertDialog(
                title: const Text("Change mode?"),
                content: const Text("Optimistic mode means everything is awesome. Are you sure you can handle that?"),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('NO THANKS'),
                      onPressed: () {
                        Navigator.pop(context, false);
                      }
                  ),
                  new FlatButton(
                      child: const Text('AGREE'),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }
                  ),
                ]
            )
        ).then<Null>(_handleOptimismChanged);
        break;
    }
  }

  Widget buildSettingsPane(BuildContext context) {
    final List<Widget> rows = <Widget>[
      new ListTile(
        leading: const Icon(Icons.thumb_up),
        title: const Text('Everything is awesome'),
        onTap: _confirmOptimismChange,
        trailing: new Checkbox(
          value: widget.configuration.appMode == AppMode.optimistic,
          onChanged: (bool value) => _confirmOptimismChange(),
        ),
      ),
    ];
    return new ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: buildAppBar(context),
        body: buildSettingsPane(context)
    );
  }
}
