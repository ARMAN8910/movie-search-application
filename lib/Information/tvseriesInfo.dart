import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:moviesapp/Repeated_fn/UserReview.dart';
import 'package:moviesapp/Repeated_fn/slide_operation.dart';
import '../HomePage/HomePage.dart';
import '../Repeated_fn/Favorite_fn.dart';
import '../Repeated_fn/repeatedtxt.dart';
import 'package:moviesapp/ApiKey/apikey.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TvSeriesDetails extends StatefulWidget {
  var id;

  TvSeriesDetails({required this.id});

  @override
  _TvSeriesDetailsState createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
  List<Map<String, dynamic>> tvSeriesDetails = [];
  List<Map<String, dynamic>> userReviews = [];
  List<Map<String, dynamic>> recommendedSeriesList = [];

  Future<void> fetchTvSeriesDetails() async {
    final tvSeriesDetailUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}?api_key=$apikey';
    final userReviewUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}/reviews?api_key=$apikey';
    final recommendedSeriesUrl =
        'https://api.themoviedb.org/3/tv/${widget.id}/recommendations?api_key=$apikey';

    final tvSeriesDetailResponse = await http.get(Uri.parse(tvSeriesDetailUrl));
    if (tvSeriesDetailResponse.statusCode == 200) {
      final tvSeriesDetailJson = jsonDecode(tvSeriesDetailResponse.body);
      for (var i = 0; i < 1; i++) {
        tvSeriesDetails.add({
          "backdrop_path": tvSeriesDetailJson['backdrop_path'],
          "title": tvSeriesDetailJson['name'],
          "vote_average": tvSeriesDetailJson['vote_average'],
          "overview": tvSeriesDetailJson['overview'],
          "release_date": tvSeriesDetailJson['first_air_date'],
        });
      }
    } else {}

    final userReviewResponse = await http.get(Uri.parse(userReviewUrl));
    if (userReviewResponse.statusCode == 200) {
      final userReviewJson = jsonDecode(userReviewResponse.body);
      for (var i = 0; i < userReviewJson['results'].length; i++) {
        userReviews.add({
          "name": userReviewJson['results'][i]['author'],
          "review": userReviewJson['results'][i]['content'],
          "rating": userReviewJson['results'][i]['author_details']['rating'] == null
              ? "Not Rated"
              : userReviewJson['results'][i]['author_details']['rating'].toString(),
          "avatarphoto": userReviewJson['results'][i]['author_details']['avatar_path'] == null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500${userReviewJson['results'][i]['author_details']['avatar_path']}",
          "creationdate": userReviewJson['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": userReviewJson['results'][i]['url'],
        });
      }
    } else {}

    final recommendedSeriesResponse = await http.get(Uri.parse(recommendedSeriesUrl));
    if (recommendedSeriesResponse.statusCode == 200) {
      final recommendedSeriesJson = jsonDecode(recommendedSeriesResponse.body);
      for (var i = 0; i < recommendedSeriesJson['results'].length; i++) {
        recommendedSeriesList.add({
          "poster_path": recommendedSeriesJson['results'][i]['poster_path'],
          "name": recommendedSeriesJson['results'][i]['name'],
          "vote_average": recommendedSeriesJson['results'][i]['vote_average'],
          "Date": recommendedSeriesJson['results'][i]['first_air_date'],
          "id": recommendedSeriesJson['results'][i]['id'],
        });
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
        future: fetchTvSeriesDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () {
                      SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.manual,
                        overlays: [SystemUiOverlay.bottom],
                      );
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      Navigator.pop(context);
                    },
                    icon: Icon(FontAwesomeIcons.circleArrowLeft),
                    iconSize: 28,
                    color: Color.fromARGB(255, 3, 221, 245),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MyHomePage()),
                          (route) => false,
                        );
                      },
                      icon: Icon(FontAwesomeIcons.houseUser),
                      iconSize: 25,
                      color: Color.fromARGB(255, 3, 221, 225),
                    )
                  ],
                  backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                  centerTitle: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: FittedBox(
                      fit: BoxFit.fill,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${tvSeriesDetails[0]['backdrop_path']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    addtofavoriate(
                      id: widget.id,
                      type: 'tv',
                      Details: tvSeriesDetails,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: tittletext('Series Overview :'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: overviewtext(tvSeriesDetails[0]['overview'].toString()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: ReviewUI(revdeatils: userReviews),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: normaltext(
                        'Release Date : ${tvSeriesDetails[0]['release_date']}',
                      ),
                    ),
                    sliderlist(
                      recommendedSeriesList,
                      "Recommended Series",
                      "tv",
                      recommendedSeriesList.length,
                    ),
                  ]),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 7, 255, 234),
              ),
            );
          }
        },
      ),
    );
  }
}