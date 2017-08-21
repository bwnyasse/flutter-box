
import 'package:flutter/material.dart';
import 'oloodi_types.dart';
import 'oloodi_data.dart';
import 'oloodi_list.dart';

enum OloodiHomeTab { formations, schools }

class _NotImplementedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Not Implemented'),
      content: const Text('This feature has not yet been implemented.'),
      actions: <Widget>[
        new FlatButton(
          onPressed: debugDumpApp,
          child: new Row(
            children: <Widget>[
              const Icon(
                Icons.dvr,
                size: 18.0,
              ),
              new Container(
                width: 8.0,
              ),
              const Text('DUMP APP TO CONSOLE'),
            ],
          ),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('OH WELL'),
        ),
      ],
    );
  }
}

class OloodiHome extends StatefulWidget {

  const OloodiHome(this.formationSearchResponse, this.schoolSearchResponse, this.configuration, this.updater);

  final FormationSearchResponse formationSearchResponse;
  final SchoolSearchResponse schoolSearchResponse;
  final OloodiConfiguration configuration;
  final ValueChanged<OloodiConfiguration> updater;

  @override
  OloodiHomeState createState() => new OloodiHomeState();
}

class OloodiHomeState extends State<OloodiHome> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isSearching = false;

  // Handle On Action
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

  void _handleOloodiModeChange(OloodiMode value) {
    if (widget.updater != null)
      widget.updater(widget.configuration.copyWith(oloodiMode: value));
  }

  void _handleShowSettings() {
    Navigator.popAndPushNamed(context, '/settings');
  }

  void _handleShowAbout() {
    showAboutDialog(context: context);
  }

  // Build Widget
  Widget buildAppBar() {
    return new AppBar(
      elevation: 0.0,
      title: new Text("Oloodi"),
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearchBegin,
          tooltip: 'Search',
        ),
      ],
      bottom: new TabBar(
        tabs: <Widget>[
          new Tab(text: "Formations"),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return new AppBar(
      leading: new BackButton(
        color: Theme.of(context).accentColor,
      ),
      title: new TextField(
        controller: _searchQuery,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Rechercher une formation',
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          const DrawerHeader(child: const Center(child: const Text('Oloodi'))),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.thumb_up),
            title: const Text('Optimistic'),
            trailing: new Radio<OloodiMode>(
              value: OloodiMode.optimistic,
              groupValue: widget.configuration.oloodiMode,
              onChanged: _handleOloodiModeChange,
            ),
            onTap: () {
              _handleOloodiModeChange(OloodiMode.optimistic);
            },
          ),
          new ListTile(
            leading: const Icon(Icons.thumb_down),
            title: const Text('Pessimistic'),
            trailing: new Radio<OloodiMode>(
              value: OloodiMode.pessimistic,
              groupValue: widget.configuration.oloodiMode,
              onChanged: _handleOloodiModeChange,
            ),
            onTap: () {
              _handleOloodiModeChange(OloodiMode.pessimistic);
            },
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: _handleShowSettings,
          ),
          new ListTile(
            leading: const Icon(Icons.help),
            title: const Text('About'),
            onTap: _handleShowAbout,
          ),
        ],
      ),
    );
  }

  Widget _buildFormationTab(BuildContext context, OloodiHomeTab tab) {
    return new Builder(
      key: new ValueKey<OloodiHomeTab>(tab),
      builder: (BuildContext context) {
        return _buildFormationList(context, widget.formationSearchResponse, tab);
      },
    );
  }

  Widget _buildFormationList(BuildContext context, FormationSearchResponse formationSearchResponse, OloodiHomeTab tab) {
    return new FormationList(
      response: formationSearchResponse,
/*      onAction: _buyStock,
      onOpen: (Stock stock) {
       // Navigator.pushNamed(context, '/stock:${stock.symbol}');
      },
      onShow: (Stock stock) {
        _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) => new StockSymbolBottomSheet(stock: stock));
      },*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 1,
      child: new Scaffold(
        //key: _scaffoldKey,
        appBar: _isSearching ? buildSearchBar() : buildAppBar(),
       // floatingActionButton: buildFloatingActionButton(),
        drawer: _buildDrawer(context),
        body: new TabBarView(
          children: <Widget>[
            _buildFormationTab(context, OloodiHomeTab.formations),
          ],
        ),
      ),
    );
  }
}