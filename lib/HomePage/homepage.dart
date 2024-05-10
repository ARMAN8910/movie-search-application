import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moviesapp/apikey/apikey.dart';
import 'package:moviesapp/information/check.dart';
import 'package:moviesapp/repeated_fn/searchfunc.dart';
import 'package:moviesapp/repeated_fn/repeatedtxt.dart';
import 'package:moviesapp/Sections/Movies.dart';
import 'package:moviesapp/Sections/TvSeries.dart';
import 'package:moviesapp/repeated_fn/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> trending = [];
  int val = 1;

  Future<void> trendinglist(int checkerno) async {
    try{
    if (checkerno == 1) {
      var trendingWeeklyUrl =
          'https://api.themoviedb.org/3/trending/all/week?api_key=$apikey';
      var trendingWeeklyResponse = await http.get(Uri.parse(trendingWeeklyUrl));
      print(trendingWeeklyResponse.statusCode);
      if (trendingWeeklyResponse.statusCode == 200) {
        var trendingJson = jsonDecode(trendingWeeklyResponse.body)['results'];
        for (var i = 0; i < 5; i++) {
          trending.add({
            'id': trendingJson[i]['id'],
            'poster_path': trendingJson[i]['poster_path'],
            'vote_average': trendingJson[i]['vote_average'],
            'media_type': trendingJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (checkerno == 2) {
      var trendingDailyUrl =
          'https://api.themoviedb.org/3/trending/all/day?api_key=$apikey';
      var trendingDailyResponse = await http.get(Uri.parse(trendingDailyUrl));
      if (trendingDailyResponse.statusCode == 200) {
        var trendingJson = jsonDecode(trendingDailyResponse.body)['results'];
        for (var i = 0; i < 5; i++) {
          trending.add({
            'id': trendingJson[i]['id'],
            'poster_path': trendingJson[i]['poster_path'],
            'vote_average': trendingJson[i]['vote_average'],
            'media_type': trendingJson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
      
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      drawer: drawerfunc(),
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.903),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromRGBO(0, 0, 0,0.903),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trending',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton(
                      autofocus: true,
                      underline: Container(height: 0, color: Colors.transparent),
                      dropdownColor: Colors.black.withOpacity(0.6),
                      icon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Color.fromARGB(255, 243, 3, 111),
                        size: 30,
                      ),
                      value: val,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'Weekly',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.purple,
                              fontSize: 16,
                            ),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Daily',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.purple,
                              fontSize: 16,
                            ),
                          ),
                          value: 2,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          val = int.parse(value.toString());
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendinglist(val),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        height: MediaQuery.of(context).size.height,
                      ),
                      items: trending.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => descriptioncheckui(i['id'], i['media_type']),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken,
                                    ),
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${i['poster_path']}',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            ' # ${i['indexno'] + 1}',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 246, 79, 79).withOpacity(0.7),
                                              fontSize: 18,
                                            ),
                                          ),
                                          margin: EdgeInsets.only(left: 10, bottom: 6),
                                        ),
                                        Container(
                                              margin: EdgeInsets.only(right: 8, bottom: 5),
                                             width: 90,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(255, 7, 230, 255).withOpacity(0.2),
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(Icons.star, color: Colors.amber, size: 20),
                                                  SizedBox(width: 10),
                                                  Column(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${i['vote_average']}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Imdb',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(color: const Color.fromARGB(255, 7, 255, 176)),
                    );
                  }
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              searchbarfun(),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1), 
                    isScrollable: true,
                      controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 62, 250, 240).withOpacity(0.4),
                    ),
                tabs: [
                    Tab(child: Tabbartext('TvSeries')),
                    Tab(child: Tabbartext(' Movies ')),
                    ],
                  ),
              ),
              Container(
                height: 1100,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    TvSeries(),
                    Movie(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}