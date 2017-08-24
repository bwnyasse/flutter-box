/**
 * Copyright (c) 2017 flutter_box. All rights reserved
 *
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 *
 * DO NOT ALTER OR REMOVE THIS HEADER.
 *
 * Created on : 24/08/17
 * Author     : bwnyasse
 *
 */

///
///Transforme une map de [data] en une requête paramétrée
///Exemple: (param1:value1 , param2:value2) => ?param1=value1&param2=value2
///
String encodeMapQueryParametersAsUrl(Map data) =>
    "?" + data.keys.map((key) => "${Uri.encodeComponent(key)}=${Uri
        .encodeComponent(data[key])}").join("&");


///
///Transforme une list en Url Path
///Exemple:  [one, two, three] => one/two/three
///
String toUrlPath(List path) {
  StringBuffer sb = new StringBuffer();
  path.forEach((item) {
    sb.write(item);
    sb.write("/");
  });
  return sb.toString();
}