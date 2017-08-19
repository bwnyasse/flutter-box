import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {


  Widget _getImageSection() =>
      new Image.asset(
        'images/lake.jpg',
        width: 600.0,
        height: 240.0,
        fit: BoxFit.cover,
      );

  Widget _getTextSection() =>
      new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Text(
          '''
    Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. 
    Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. 
    A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, 
    leads you to the lake, which warms to 20 degrees Celsius in the summer. 
    Activities enjoyed here include rowing, and riding the summer toboggan run.
    ''',
          softWrap: true,
        ),
      );

  Widget _getButtonSection(BuildContext context,) =>
      new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButtonColumn(context, Icons.call, 'CALL'),
              _buildButtonColumn(context, Icons.near_me, 'ROUTE'),
              _buildButtonColumn(context, Icons.share, 'SHARE')
            ],
          )
      );

  Column _buildButtonColumn(BuildContext context, IconData icon,
      String label) =>
      new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(icon, color: Theme
              .of(context)
              .primaryColor),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Theme
                      .of(context)
                      .primaryColor),
            ),
          ),
        ],
      );

  Widget _getTitleSection() =>
      new Container(
          padding: const EdgeInsets.all(32.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          'Oeschinen Lake Campground',
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      new Text(
                        'Kandersteg, Switzerland',
                        style: new TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  )
              ),
              new Icon(
                Icons.star,
                color: Colors.red[500],
              ),
              new Text('41'),
            ],)
      );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Building Layout Tuto',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Hot Reload App in IntelliJ). Notice that the counter
          // didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Top Lakes'),
          ),
          body: new ListView(
            children: <Widget>[
              _getImageSection(),
              _getTitleSection(),
              _getButtonSection(context),
              _getTextSection()
            ],),
        )
    );
  }
}