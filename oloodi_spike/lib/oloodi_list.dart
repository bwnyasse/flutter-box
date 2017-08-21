import 'package:flutter/material.dart';

import 'oloodi_data.dart';
import 'oloodi_row.dart';

class FormationList extends StatelessWidget {
  const FormationList({ Key key, this.response, this.onOpen, this.onShow, this.onAction }) : super(key: key);

  final FormationSearchResponse response;
  final FormationRowActionCallback onOpen;
  final FormationRowActionCallback onShow;
  final FormationRowActionCallback onAction;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: const ValueKey<String>('formation-list'),
      itemExtent: FormationRow.kHeight,
      itemCount: response?.formations?.length,
      itemBuilder: (BuildContext context, int index) {
        return new FormationRow(
            formation: response?.formations[index],
            onPressed: onOpen,
            onDoubleTap: onShow,
            onLongPressed: onAction
        );
      },
    );
  }
}
