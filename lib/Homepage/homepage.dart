import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/SectionPage/movie.dart';
import 'package:movie_app/SectionPage/tvseries.dart';
import 'package:movie_app/SectionPage/upcoming.dart';
import 'dart:convert';

import 'package:movie_app/apikey/api_key.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_app/repeatedfunction/serachbarfunc.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin{
  List<Map<String, dynamic>> trendingweek = [];
  int uval = 1;
  Future<void> trendinglist(int checkerno) async {
    if (checkerno == 1) {
      var trendingweekurl =
          'https://api.themoviedb.org/3/trending/all/week?api_key=$apikey';
      var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
      if (trendingweekresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingweekresponse.body);
        var trendingweekjson = tempdata['results'];
        for (var i = 0; i < trendingweekjson.length; i++) {
          trendingweek.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (checkerno == 2) {
      var trendingweekurl =
          'https://api.themoviedb.org/3/trending/all/day?api_key=$apikey';
      var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
      if (trendingweekresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingweekresponse.body);
        var trendingweekjson = tempdata['results'];
        for (var i = 0; i < trendingweekjson.length; i++) {
          trendingweek.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    }
    // print(trendingweek);
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: CustomScrollView(slivers: [SliverAppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Trending' + ' 🔥',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 16)),
                  SizedBox(width: 10),
                  Container(height: 45,
                            decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                            child: Padding(padding: const EdgeInsets.all(4.0),
                            child: DropdownButton( autofocus: true,
                        underline:
                            Container(height: 0, color: Colors.transparent),
                                                    dropdownColor: Colors.black.withOpacity(0.6),
                        icon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.amber,
                          size: 30,
                        ),
                        value: uval,
                                                  items: [
                          DropdownMenuItem(
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white,
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
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            value: 2,
                          ),
                        ],
                        onChanged: (value){
                          setState(() {
                            trendingweek.clear();
                            uval = int.parse(value.toString());
                          });
                        },),),)

        ],),
        centerTitle: true,
        toolbarHeight: 60,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
        flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.parallax,
                                        background: FutureBuilder(future: trendinglist(uval), 
                                                                  builder:  (context, snapshot){
                                                                    if(snapshot.connectionState==ConnectionState.done){
                                                                      return CarouselSlider(options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 2),
                            height: MediaQuery.of(context).size.height),items: trendingweek.map((i){
                              return Builder(builder: (BuildContext context){
                                return GestureDetector(onTap: (){},
                                child: GestureDetector(onTap: (){},child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.3),
                                                    BlendMode.darken),
                                                image: NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500${i['poster_path']}'),
                                                fit: BoxFit.fill)),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                                children: [Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [Container(
                                                    child: Text(
                                                        ' # '
                                                        '${i['indexno'] + 1}',
                                                        style: TextStyle(
                                                            color: Colors.amber
                                                                .withOpacity(
                                                                    0.7),
                                                            fontSize: 18),
                                                      ),
                                                    margin: EdgeInsets.only(
                                                          left: 10, bottom: 6),
                                                                                                            )],
                                                ),
                                                          Container(margin: EdgeInsets.only(
                                                            right: 8,
                                                            bottom: 5),
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber
                                                                .withOpacity(
                                                                    0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                          child: Row(mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              //rating icon
                                                              Icon(Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                  size: 20),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                  '${i['vote_average']}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400))
                                                            ]),)],),
                                ),),);


                              });
                            }).toList(),);
                                                                    }
                                                                    else{
                                                                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.amber,
                      ));

                                                                    }
                                                                  }),),
      ),
      SliverList(delegate: SliverChildListDelegate([Serachbarfunc(),Container(height: 45,
                width: MediaQuery.of(context).size.width,
                child: TabBar(physics: BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amber.withOpacity(0.4)),
                    tabs: [Tab(child: Text('Tv Series')),
                      Tab(child: Text('Movies')),
                      Tab(child: Text('Upcoming'))],),),
                      Container(height: 1100,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(controller: _tabController,children: const[Tvseries(),
                  Movie(),
                  Upcoming(),]),)]))],),

    );
  }
}