import 'package:flutter/material.dart';

import 'oloodi_data.dart';

typedef void FormationRowActionCallback(Formation formation);

class FormationRow extends StatelessWidget {
  FormationRow({
    this.formation,
    this.onPressed,
    this.onDoubleTap,
    this.onLongPressed
  }) : super(key: new ObjectKey(formation));

  final Formation formation;
  final FormationRowActionCallback onPressed;
  final FormationRowActionCallback onDoubleTap;
  final FormationRowActionCallback onLongPressed;

  static const double kHeight = 79.0;

  GestureTapCallback _getHandler(FormationRowActionCallback callback) {
    return callback == null ? null : () => callback(formation);
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: _getHandler(onPressed),
        onDoubleTap: _getHandler(onDoubleTap),
        onLongPress: _getHandler(onLongPressed),
        child: new Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(color: Theme.of(context).dividerColor)
                )
            ),
            child: new Row(
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      child: new Hero(
                          tag: formation,
                          child: new Image.network(formation.getLogoLink(), fit: BoxFit.cover)
                      )
                  ),
                  new Expanded(
                      child: new Row(
                          children: <Widget>[
                            new Expanded(
                                flex: 2,
                                child: new Text(
                                    formation.name
                                )
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: DefaultTextStyle.of(context).style.textBaseline
                      )
                  ),
                ]
            )
        )
    );
  }
}