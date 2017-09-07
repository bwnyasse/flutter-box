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


class MoviesResponse {
  String page;
  String totalResults;
  String totalPages;
  List<MovieEntry> searchMovieEntries = [];

  MoviesResponse.fromJson(Map json) {
    this.page = json['page'].toString();
    this.totalResults = json['total_results'].toString();
    this.totalPages = json['total_pages'].toString();
    List results = json['results'];
    results.forEach((entry) {
      searchMovieEntries.add(new MovieEntry.fromJson(entry));
    });
  }
}

class MovieEntry {
  String posterPath;
  bool adult;
  String overview;
  String releaseDate;
  List genreIds;
  String id;
  String originalTitle;
  String originalLanguage;
  String title;
  String backdropPath;
  String popularity;
  String voteCount;
  bool video;
  String voteAverage;

  MovieEntry.fromEmpty(){
    originalTitle = "";
  }

  MovieEntry.fromJson(Map json) {
    this.posterPath = json['poster_path'].toString();
    this.adult = json['adult'].toString() == "true";
    this.overview = json['overview'].toString();
    this.id = json['id'].toString();
    this.originalTitle = json['original_title'].toString();
    this.originalLanguage = json['original_language'].toString();
    this.releaseDate = json['release_date'].toString();
    this.title = json['title'].toString();
    this.backdropPath = json['backdrop_path'].toString();
    this.popularity = json['popularity'].toString();
    this.voteCount = json['vote_count'].toString();
    this.video = json['video'].toString() == "true";
    this.voteAverage = json['vote_average'].toString();
  }
}