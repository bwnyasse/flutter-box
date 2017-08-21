import 'dart:math';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart' as quiver_strings;

String encodeMap(Map data) =>
    data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri
        .encodeComponent(data[key])}").join("&");

///
///Transforme une map de [data] en une requête url
///s
///Exemple: (param1:value1 , param2:value2) => ?param1=value1&param2=value2
///
String encodeMapQueryParametersAsUrl(Map data) =>
    "?" + data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri
        .encodeComponent(data[key])}").join("&");

///
///Recupère la value de l'année courante
///
String currentYear() =>
    new DateFormat('yyyy').format(new DateTime.now()).toString();

String toUrl(List path) {
  StringBuffer sb = new StringBuffer();
  path.forEach((item) {
    sb.write(item);
    sb.write("/");
  });
  return sb.toString();
}

///
///Generates a positive random integer uniformly distributed on the range
///from [min], inclusive, to [max], exclusive.
///
int nextInt(int min, int max) => min + new Random().nextInt(max - min);


Iterable<int> range(int low, int high) sync* {
  for (int i = low; i < high; ++i) {
    yield i;
  }
}

String capitalize(String s) => quiver_strings.isNotEmpty(s) ? s[0].toUpperCase() + s.substring(1) : "";

Map listToMap(List l) {
  final m = {};
  l.forEach((e){
    m[e.key] = e.value;
  });
  return m;
}

isoToCountry(String iso, List countryIso) {
  if(countryIso != null){
    return countryIso.where((entry) {
      return quiver_strings.equalsIgnoreCase(entry.index, iso);
    }).first?.name;
  }
}
