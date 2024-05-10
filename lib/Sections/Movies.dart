import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moviesapp/ApiKey/apikey.dart';

import 'package:moviesapp/Repeated_fn/slide_operation.dart';

class Movie extends StatefulWidget {
  const Movie({Key? key}) : super(key: key);

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  List<Map<String, dynamic>> popularMovies = [];
  List<Map<String, dynamic>> topRatedMovies = [];

  Future<void> fetchMovies() async {
    var popularMoviesUrl = 'https://api.themoviedb.org/3/movie/popular?api_key=$apikey';
    var topRatedMoviesUrl =  'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey';

    var popularMoviesResponse = await http.get(Uri.parse(popularMoviesUrl));
    if (popularMoviesResponse.statusCode == 200) {
      var popularMoviesJson = jsonDecode(popularMoviesResponse.body)['results'];
      for (var movie in popularMoviesJson) {
        popularMovies.add({
          "name": movie["title"],
          "poster_path": movie["poster_path"],
          "vote_average": movie["vote_average"],
          "Date": movie["release_date"],
          "id": movie["id"],
        });
      }
    } else {
      print(popularMoviesResponse.statusCode);
    }

    var topRatedMoviesResponse = await http.get(Uri.parse(topRatedMoviesUrl));
    if (topRatedMoviesResponse.statusCode == 200) {
      var topRatedMoviesJson = jsonDecode(topRatedMoviesResponse.body)['results'];
      for (var movie in topRatedMoviesJson) {
        topRatedMovies.add({
          "name": movie["title"],
          "poster_path": movie["poster_path"],
          "vote_average": movie["vote_average"],
          "Date": movie["release_date"],
          "id": movie["id"],
        });
      }
    } else {
      print(topRatedMoviesResponse.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 13, 235, 179)));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sliderlist(popularMovies, "Popular Movies", "movie", 20),
              sliderlist(topRatedMovies, "Top Rated", "movie", 20),
            ],
          );
        }
      },
    );
  }
}