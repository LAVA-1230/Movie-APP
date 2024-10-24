import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Homepage/homepage.dart';
import 'dart:convert';
import 'package:movie_app/apikey/api_key.dart';
import 'package:movie_app/repeatedfunction/sliderlist.dart';
import 'package:movie_app/repeatedfunction/trailer.dart';

class Tvdetails extends StatefulWidget {
  var id;
  Tvdetails(this.id);

  @override
  State<Tvdetails> createState() => _TvdetailsState();
}

class _TvdetailsState extends State<Tvdetails> {
  var tvseriesdetaildata;
  List<Map<String, dynamic>> TvSeriesDetails = [];
  List<Map<String, dynamic>> TvSeriesREview = [];
  List<Map<String, dynamic>> similarserieslist = [];
  List<Map<String, dynamic>> recommendserieslist = [];
  List<Map<String, dynamic>> seriestrailerslist = [];

  Future<void> tvseriesdetailfunc() async {
    var tvseriesdetailurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '?api_key=$apikey';
    var similarseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';
    var recommendseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';
    var seriestrailersurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/videos?api_key=$apikey';
    // 'https://api.themoviedb.org/3/tv/' +
    //     widget.id.toString() +
    //     '/videos?api_key=$apikey';

    var tvseriesdetailresponse = await http.get(Uri.parse(tvseriesdetailurl));
    if (tvseriesdetailresponse.statusCode == 200) {
      tvseriesdetaildata = jsonDecode(tvseriesdetailresponse.body);
      for (var i = 0; i < 1; i++) {
        TvSeriesDetails.add({
          'backdrop_path': tvseriesdetaildata['backdrop_path'],
          'title': tvseriesdetaildata['original_name'],
          'vote_average': tvseriesdetaildata['vote_average'],
          'overview': tvseriesdetaildata['overview'],
          'status': tvseriesdetaildata['status'],
          'releasedate': tvseriesdetaildata['first_air_date'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['genres'].length; i++) {
        TvSeriesDetails.add({
          'genre': tvseriesdetaildata['genres'][i]['name'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['created_by'].length; i++) {
        TvSeriesDetails.add({
          'creator': tvseriesdetaildata['created_by'][i]['name'],
          'creatorprofile': tvseriesdetaildata['created_by'][i]['profile_path'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['seasons'].length; i++) {
        TvSeriesDetails.add({
          'season': tvseriesdetaildata['seasons'][i]['name'],
          'episode_count': tvseriesdetaildata['seasons'][i]['episode_count'],
        });
      }
    } else {}
    ///////////////////////////////////////////similar series

    var similarseriesresponse = await http.get(Uri.parse(similarseriesurl));
    if (similarseriesresponse.statusCode == 200) {
      var similarseriesdata = jsonDecode(similarseriesresponse.body);
      for (var i = 0; i < similarseriesdata['results'].length; i++) {
        similarserieslist.add({
          'poster_path': similarseriesdata['results'][i]['poster_path'],
          'name': similarseriesdata['results'][i]['original_name'],
          'vote_average': similarseriesdata['results'][i]['vote_average'],
          'id': similarseriesdata['results'][i]['id'],
          'Date': similarseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}
    ///////////////////////////////////////////recommend series

    var recommendseriesresponse = await http.get(Uri.parse(recommendseriesurl));
    if (recommendseriesresponse.statusCode == 200) {
      var recommendseriesdata = jsonDecode(recommendseriesresponse.body);
      for (var i = 0; i < recommendseriesdata['results'].length; i++) {
        recommendserieslist.add({
          'poster_path': recommendseriesdata['results'][i]['poster_path'],
          'name': recommendseriesdata['results'][i]['original_name'],
          'vote_average': recommendseriesdata['results'][i]['vote_average'],
          'id': recommendseriesdata['results'][i]['id'],
          'Date': recommendseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    ///////////////////////////////////////////tvseries trailer///////////////////////////////////////////
    var tvseriestrailerresponse = await http.get(Uri.parse(seriestrailersurl));
    if (tvseriestrailerresponse.statusCode == 200) {
      var tvseriestrailerdata = jsonDecode(tvseriestrailerresponse.body);
      // print(tvseriestrailerdata);
      for (var i = 0; i < tvseriestrailerdata['results'].length; i++) {
        //add only if type is trailer
        if (tvseriestrailerdata['results'][i]['type'] == "Trailer") {
          seriestrailerslist.add({
            'key': tvseriestrailerdata['results'][i]['key'],
          });
        }
      }
      seriestrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    print(seriestrailerslist);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
    body: FutureBuilder(future:tvseriesdetailfunc(), 
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.done){
                            return CustomScrollView(physics: BouncingScrollPhysics(),
                                                    slivers: [SliverAppBar(automaticallyImplyLeading: false,
                        leading: IconButton(
                            onPressed: () {
                              
                              Navigator.pop(context);
                            },
                            icon: Icon(FontAwesomeIcons.circleArrowLeft),
                            iconSize: 28,
                            color: Colors.white),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>Homepage()),
                                    (route) => false);
                              },
                              icon: Icon(FontAwesomeIcons.houseUser),
                              iconSize: 25,
                              color: Colors.white)
                        ],
                        backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                        centerTitle: false,
                        pinned: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.4,
                        flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.parallax,
                                                        background: FittedBox(fit: BoxFit.fill,child: trailerwatch(trailerytid: seriestrailerslist[0]['key'],),),),
                        ),
                        SliverList(delegate: SliverChildListDelegate([Column(
                        children: [
                          Row(children: [
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tvseriesdetaildata['genres']!.length,
                                    itemBuilder: (context, index) {
                                      //generes box
                                      return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(25, 25, 25, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child:
                                              Text(TvSeriesDetails[index+1]['genre'].toString()));
                                    })),
                          ]),
                          
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text('Movie Story :')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                              TvSeriesDetails[0]['overview'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text('Status'+TvSeriesDetails[0]['status'].toString()
                              )),

                      
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Release Date : ' +
                              TvSeriesDetails[0]['releasedate'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Seasons: ' +
                              tvseriesdetaildata['seasons'].length.toString())),
                      
                      sliderlist(similarserieslist, "Similar Movies", "movie",
                          similarserieslist.length),
                      sliderlist(recommendserieslist, "Recommended Movies",
                          "movie", recommendserieslist.length),]),

                                  
                          )],);

                          }
                          else{return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));}
                        }),);
  }
}