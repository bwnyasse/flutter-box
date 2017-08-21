import 'oloodi_utils.dart' as service_utils;
import 'package:bson_objectid/bson_objectid.dart';
import 'package:mdown/mdown.dart';
import 'package:quiver/strings.dart' as quiver_strings;


const String STATIC_IMAGE_URL = "http://vmi92598.contabo.host:8086";

void initEntry(List json, List list) {
  json.forEach((v) {
    list.add(new CategoryEntry(v['index'], v['name']));
  });
}

void initFilter(Map json, var list) {
  if (json != null) {
    json.forEach((k, v) {
      list.add(new FilterEntry(k, v));
    });
  }
}

class SearchResponse {}

class SearchQuery {
  String key;
  String value;

  SearchQuery(this.key, this.value);
}

class FilterEntry {
  String name;
  int size;

  FilterEntry(this.name, this.size);
}


class CategoryEntry {
  int index;
  String name;

  CategoryEntry(this.index, this.name);
}

// -------------- Category ---------------------//
class Category {
  List<CategoryEntry> domain = [];
  List<CategoryEntry> state = [];
  List<CategoryEntry> type = [];
  List<CategoryEntry> outDiploma = [];
  List<CategoryEntry> languages = [];
  List<CategoryEntry> inTicket = [];
  List<CategoryEntry> duration = [];
  List<CategoryEntry> countryIso = [];

  Category.fromJson(Map<String, dynamic> json){
    initEntry(json['category']['domain'], domain);
    initEntry(json['category']['state'], state);
    initEntry(json['category']['type'], type);
    initEntry(json['category']['outDiploma'], outDiploma);
    initEntry(json['category']['languages'], languages);
    initEntry(json['category']['inTicket'], inTicket);
    initEntry(json['category']['duration'], duration);
    initEntry(json['category']['countryIso'], countryIso);
  }

  String getByIndex(String index, List<CategoryEntry> list) {
    List<CategoryEntry> entries = list.where((el) {
      return el.index == index;
    });
    return entries.isNotEmpty ? entries.first.name : "";
  }

  String getIsoFlag(int size, String iso) =>
      quiver_strings.isEmpty(iso) ? "" : STATIC_IMAGE_URL +
          "/local/small_light(dh=$size,da=l,ds=s)/images/flags/" +
          iso.toLowerCase() + ".png";
}

// -------------- Geoloc ---------------------//
class Geoloc {
  String latitude;
  String longitude;
  String address;
  String locality;
  String country;
  String iso;
  String area;

  // Constructor
  Geoloc(this.latitude,
      this.longitude,
      this.address,
      this.locality,
      this.country,
      this.iso,
      this.area);

  Geoloc.empty()
      : this(
      "",
      "",
      "",
      "",
      "",
      "",
      "");

  Geoloc.fromJson(Map<String, dynamic> json)
      : this(
      json['latitude'].toString() != null ? json['latitude'].toString() : "",
      json['longitude'].toString() != null ? json['longitude'].toString() : "",
      json['address'].toString() != null ? json['address'].toString() : "",
      json['locality'].toString() != null ? json['locality'].toString() : "",
      json['country'].toString() != null ? json['country'].toString() : "",
      json['iso'].toString() != null ? json['iso'].toString() : "",
      json['area'].toString() != null ? json['area'].toString() : "");

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'locality': locality,
        'country': country,
        'iso': iso,
        'area': area
      };
}

// -------------- Manager --------------------//
class Manager {
  String id;
  String code;
  String name;
  String email;
  String password;

  Manager(this.id,
      this.name,
      this.email,
      this.password);

  Manager.empty()
      : this(
      new ObjectId().toHexString(),
      "",
      "",
      "");

  Manager.fromEmpty();

  Manager.fromJson(Map json){
    this.id = json['id'].toString();
    this.name = json['name'].toString();
    this.code = json['code'].toString();
    this.email = json['email'].toString();
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'name': name,
        'code': code,
        'email': email,
        'password': password,
      };
}

// -------------- Department -----------------//
class DepartmentResponse {
  Department department;
  Manager manager;

  DepartmentResponse.fromJson(Map<String, dynamic> json) {
    this.department = new Department.fromJson(json['department']);
    if (json['manager'] != null) {
      this.manager = new Manager.fromJson(json['manager']);
    }
  }

}

class Department {
  String id;
  String name;
  String description;
  String url;
  School school;

  // Constructor
  Department(this.id,
      this.name,
      this.description,
      this.url);

  Department.empty()
      : this(
      new ObjectId().toHexString(),
      "",
      "",
      "");

  Department.fromJson(Map<String, dynamic> json) {
    this.id = json['id'].toString();
    this.name = json['name'].toString();
    this.description = json['description'].toString();
    this.url = json['url'].toString();
    if (json['school'] != null) {
      this.school = new School.fromJson(json['school']);
    }
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'url': url
      };

  descriptionAsMarkdown() => markdownToHtml(description);
}

// -------------- School -----------------//
class SchoolSearchResponse implements SearchResponse {
  int totalSize;
  int pageCount;
  int pageNumber;

  // Facets Filter
  List<FilterEntry> stateFilters = [];
  List<FilterEntry> typeFilters = [];
  List<FilterEntry> isoFilters = [];
  List<FilterEntry> localityFilters = [];

  List<School> schools = [];

  getRangeSize() => service_utils.range(1, pageCount + 1);

  SchoolSearchResponse.fromJson(Map json){
    totalSize = int.parse(json['totalSize']);
    pageCount = int.parse(json['pageCount']);
    pageNumber = int.parse(json['pageNumber']);
    json['schools'].forEach((json) {
      schools.add(new School.fromJson(json));
    });
    initFilter(json['stateFilters'], stateFilters);
    initFilter(json['typeFilters'], typeFilters);
    initFilter(json['isoFilters'], isoFilters);
    initFilter(json['localityFilters'], localityFilters);
  }

}

class SchoolResponse {
  String departmentCount;
  String formationCount;
  School school;

  SchoolResponse.fromJson(Map json){
    departmentCount = json['departmentCount'];
    formationCount = json['formationCount'];
    school = new School.fromJson(json['school']);
  }
}

class School {
  String id;
  String code;
  String name;
  String state;
  String type;
  String url;
  String description;
  Geoloc geolocation = new Geoloc.empty();
  String logo;
  String facebook;
  String twitter;
  String linkedin;

  // Constructor
  School(this.id,
      this.code,
      this.name,
      this.state,
      this.type,
      this.url,
      this.description,
      this.geolocation,
      this.logo,
      this.facebook,
      this.twitter,
      this.linkedin);

  School.empty()
      : this(
      new ObjectId().toHexString(),
      "",
      "",
      "",
      "",
      "",
      "",
      new Geoloc.empty(),
      "",
      "",
      "",
      "");

  School.fromJson(Map<String, dynamic> json)
      : this(
      json['id'].toString(),
      json['code'].toString(),
      json['name'].toString(),
      json['state'].toString(),
      json['type'].toString(),
      json['url'].toString(),
      json['description'].toString(),
      new Geoloc.fromJson(json['geolocation']),
      json['logo'].toString(),
      json['facebook'].toString(),
      json['twitter'].toString(),
      json['linkedin'].toString());

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'code': code,
        'name': name,
        'state': state,
        'type': type,
        'url': url,
        'description': description,
        'logo': logo,
        'geolocation': geolocation,
        'facebook': facebook,
        'twitter': twitter,
        'linkedin': linkedin
      };

  descriptionAsMarkdown() => markdownToHtml(description);

  getLogoLink([size = 150]) =>
      quiver_strings.isEmpty(code) ? "" : STATIC_IMAGE_URL +
          "/local/small_light(dh=$size,da=l,ds=s)/images/logo/" + code +
          "/logo.jpg";

  getFlag([size = 24]) =>
      quiver_strings.isEmpty(geolocation.iso) ? "" : STATIC_IMAGE_URL +
          "/local/small_light(dh=$size,da=l,ds=s)/images/flags/" +
          geolocation.iso.toLowerCase() + ".png";

}

// -------------- Formation -----------------//

class FormationSearchResponse implements SearchResponse   {

  int totalSize;
  int pageCount;
  int pageNumber;

  // Facets Filter
  List<FilterEntry> domainFilters = [];
  List<FilterEntry> durationFilters = [];
  List<FilterEntry> inTicketFilters = [];
  List<FilterEntry> outDiplomaFilters = [];
  List<FilterEntry> schoolCodeFilters = [];
  List<FilterEntry> schoolStateFilters = [];
  List<FilterEntry> schoolTypeFilters = [];
  List<FilterEntry> isoFilters = [];
  List<FilterEntry> localityFilters = [];

  List<Formation> formations = [];

  getRangeSize() => service_utils.range(1, pageCount + 1);

  FormationSearchResponse.fromJson(Map json){
    totalSize = int.parse(json['totalSize']);
    pageCount = int.parse(json['pageCount']);
    pageNumber = int.parse(json['pageNumber']);
    json['formations'].forEach((json) {
      formations.add(new Formation.fromJson(json));
    });
    initFilter(json['domainFilters'], domainFilters);
    initFilter(json['durationFilters'], durationFilters);
    initFilter(json['inTicketFilters'], inTicketFilters);
    initFilter(json['outDiplomaFilters'], outDiplomaFilters);
    initFilter(json['schoolCodeFilters'], schoolCodeFilters);
    initFilter(json['schoolStateFilters'], schoolStateFilters);
    initFilter(json['schoolTypeFilters'], schoolTypeFilters);
    initFilter(json['isoFilters'], isoFilters);
    initFilter(json['localityFilters'], localityFilters);
  }
}

class Formation {

  String id;
  String name;
  String description;
  String outLevel;
  String inTicket;
  String cost;
  String outDiploma;
  String languages;
  String modality;
  String domain;
  String duration;
  Department department;
  Geoloc geolocation;

  // For Search
  String departmentName;
  String schoolCode;
  String schoolType;
  String schoolState;

  Formation(this.id,
      this.name,
      this.description,
      this.outLevel,
      this.inTicket,
      this.cost,
      this.outDiploma,
      this.languages,
      this.modality,
      this.domain,
      this.duration);

  Formation.empty() :this(
      new ObjectId().toHexString(),
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "");

  Formation.fromJson(Map<String, dynamic> json) {
    this.id = json['id'].toString();
    this.name = json['name'].toString();
    this.description = json['description'].toString();
    this.outLevel = json['outLevel'].toString();
    this.inTicket = json['inTicket'].toString();
    this.cost = json['cost'].toString();
    this.outDiploma = json['outDiploma'].toString();
    this.languages = json['languages'].toString();
    this.modality = json['modality'].toString();
    this.domain = json['domain'].toString();
    this.duration = json['duration'].toString();
    this.schoolCode = json['schoolCode'].toString();
    this.schoolType = json['schoolType'].toString();
    this.schoolState = json['schoolState'].toString();
    this.departmentName = json['departmentName'].toString();

    if (json["geolocation"] != null) {
      this.geolocation = new Geoloc.fromJson(json["geolocation"]);
    }

    if (json["department"] != null) {
      this.department = new Department.fromJson(json["department"]);
    }
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'outLevel': outLevel,
        'inTicket': inTicket,
        'cost': cost,
        'outDiploma': outDiploma,
        'languages': languages,
        'modality': modality,
        'domain': domain,
        'duration': duration,
      };

  getFlag([size = 24]) =>
      quiver_strings.isEmpty(geolocation.iso) ? "" : STATIC_IMAGE_URL +
          "/local/small_light(dh=$size,da=l,ds=s)/images/flags/" +
          geolocation.iso.toLowerCase() + ".png";

  getLogoLink([size = 150]) =>
      quiver_strings.isEmpty(schoolCode) ? "" : STATIC_IMAGE_URL +
          "/local/small_light(dh=$size,da=l,ds=s)/images/logo/" + schoolCode +
          "/logo.jpg";

  descriptionAsMarkdown() => markdownToHtml(description);

  domainByIndex(Category category) =>
      service_utils.capitalize(
          category?.getByIndex(domain, category?.domain));


  inTicketByIndex(Category category) =>
      service_utils.capitalize(
          category?.getByIndex(inTicket, category?.inTicket));

  outDiplomaByIndex(Category category) =>
      service_utils.capitalize(
          category?.getByIndex(outDiploma, category.outDiploma));

  durationByIndex(Category category) =>
      service_utils.capitalize(
          category?.getByIndex(duration, category.duration));

  languagesByIndex(Category category) =>
      service_utils.capitalize(
          category?.getByIndex(languages, category.languages));
}



