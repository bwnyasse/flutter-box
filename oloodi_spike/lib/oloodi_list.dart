import 'package:flutter/material.dart';

import 'oloodi_data.dart';
import 'oloodi_http.dart' as oloodi_http;
import 'oloodi_row.dart';

class FormationList extends StatefulWidget {
  @override
  FormationListState createState() => new FormationListState();
}

class FormationListState extends State<FormationList> {

  FormationSearchResponse _formationSearchResponse;

  @override
  void initState() {
    super.initState();
    fetchFormation();
  }

  fetchFormation() async {
    FormationSearchResponse value = await oloodi_http.searchFormation();
    setState(() {
      _formationSearchResponse = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: const ValueKey<String>('formation-list'),
      itemCount: _formationSearchResponse?.formations?.length,
      itemBuilder: (BuildContext context, int index) {
        return new FormationRow(
            formation: _formationSearchResponse?.formations[index],
        );
      },
    );
  }
}

class SchoolList extends StatefulWidget {
  @override
  SchoolListState createState() => new SchoolListState();
}

class SchoolListState extends State<SchoolList> {

  SchoolSearchResponse _schoolSearchResponse;

  @override
  void initState() {
    super.initState();
    fetchSchool();
  }

  fetchSchool() async {
    SchoolSearchResponse value = await oloodi_http.searchSchool();
    setState(() {
      _schoolSearchResponse = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      key: const ValueKey<String>('school-list'),
      itemCount: _schoolSearchResponse?.schools?.length,
      itemBuilder: (BuildContext context, int index) {
        return new SchoolRow(
          school: _schoolSearchResponse?.schools[index],
        );
      },
    );
  }
}