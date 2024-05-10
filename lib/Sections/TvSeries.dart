import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moviesapp/ApiKey/apikey.dart';
import 'package:moviesapp/Repeated_fn/slide_operation.dart';

class TvSeries extends StatefulWidget {
  const TvSeries({Key? key}) : super(key: key);

  @override
  State<TvSeries> createState() => _TvSeriesState();
}

class _TvSeriesState extends State<TvSeries> {
  List<Map<String, dynamic>> populartvseries = [];
  List<Map<String, dynamic>> topratedtvseries = [];

  Future<void> tvseriesfun() async {
    var poptvseries = 'https://api.themoviedb.org/3/tv/popular?api_key=$apikey';
    var toptvseries = 'https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey';

    var populartvresponse = await http.get(Uri.parse(poptvseries));
    if (populartvresponse.statusCode == 200) {
      var temp = jsonDecode(populartvresponse.body);
      var populartvjson = temp['results'];

      for (var i = 0; i < populartvjson.length; i++) {
        populartvseries.add({
          "name": populartvjson[i]["name"],
          "poster_path": populartvjson[i]["poster_path"],
          "vote_average": populartvjson[i]["vote_average"],
          "Date": populartvjson[i]["first_air_date"],
          "id": populartvjson[i]["id"],
        });
      }
    } else {
      print(populartvresponse.statusCode);
    }

    var topratedresponse = await http.get(Uri.parse(toptvseries));
    if (topratedresponse.statusCode == 200) {
      var temp = jsonDecode(topratedresponse.body);
      var topratedseriesjson = temp['results'];

      for (var i = 0; i < topratedseriesjson.length; i++) {
        topratedtvseries.add({
          "name": topratedseriesjson[i]["name"],
          "poster_path": topratedseriesjson[i]["poster_path"],
          "vote_average": topratedseriesjson[i]["vote_average"],
          "Date": topratedseriesjson[i]["first_air_date"],
          "id": topratedseriesjson[i]["id"],
        });
      }
    } else {
      print(topratedresponse.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    tvseriesfun();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tvseriesfun(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 13, 235, 179),
            ),
          );
        else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sliderlist(populartvseries, "Popular TvSeries", "tv", 20),
              sliderlist(topratedtvseries, "TopRated TvSeries", "tv", 20),
            ],
          );
        }
      },
    );
  }
}