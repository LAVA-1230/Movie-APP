import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Homepage/homepage.dart';
import 'dart:convert';
import 'package:movie_app/apikey/api_key.dart';
import 'package:movie_app/repeatedfunction/sliderlist.dart';
import 'package:movie_app/repeatedfunction/trailer.dart';
class Moviedetails extends StatefulWidget {
  var id;
  Moviedetails(this.id);

  @override
  State<Moviedetails> createState() => _MoviedetailsState();
}

class _MoviedetailsState extends State<Moviedetails> {
  List<Map<String, dynamic>> MovieDetails = [];
  List<Map<String, dynamic>> UserREviews = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List<Map<String, dynamic>> movietrailerslist = [];

  List MoviesGeneres = [];

  Future Moviedetails() async {
    var moviedetailurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '?api_key=$apikey';
    var similarmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/similar?api_key=$apikey';
    var recommendedmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/recommendations?api_key=$apikey';
    var movietrailersurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/videos?api_key=$apikey';

    var moviedetailresponse = await http.get(Uri.parse(moviedetailurl));
    if (moviedetailresponse.statusCode == 200) {
      var moviedetailjson = jsonDecode(moviedetailresponse.body);
      for (var i = 0; i < 1; i++) {
        MovieDetails.add({
          "backdrop_path": moviedetailjson['backdrop_path'],
          "title": moviedetailjson['title'],
          "vote_average": moviedetailjson['vote_average'],
          "overview": moviedetailjson['overview'],
          "release_date": moviedetailjson['release_date'],
          "runtime": moviedetailjson['runtime'],
          "budget": moviedetailjson['budget'],
          "revenue": moviedetailjson['revenue'],
        });
      }
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGeneres.add(moviedetailjson['genres'][i]['name']);
      }
    } else {}
    
    /////////////////////////////similar movies
    var similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
    if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarmovieslist.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    } else {}
    // print(similarmovieslist);
    /////////////////////////////recommended movies
    var recommendedmoviesresponse =
        await http.get(Uri.parse(recommendedmoviesurl));
    if (recommendedmoviesresponse.statusCode == 200) {
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        recommendedmovieslist.add({
          "poster_path": recommendedmoviesjson['results'][i]['poster_path'],
          "name": recommendedmoviesjson['results'][i]['title'],
          "vote_average": recommendedmoviesjson['results'][i]['vote_average'],
          "Date": recommendedmoviesjson['results'][i]['release_date'],
          "id": recommendedmoviesjson['results'][i]['id'],
        });
      }
    } else {}
    // print(recommendedmovieslist);
    /////////////////////////////movie trailers
    var movietrailersresponse = await http.get(Uri.parse(movietrailersurl));
    if (movietrailersresponse.statusCode == 200) {
      var movietrailersjson = jsonDecode(movietrailersresponse.body);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        if (movietrailersjson['results'][i]['type'] == "Trailer") {
          movietrailerslist.add({
            "key": movietrailersjson['results'][i]['key'],
          });
        }
      }
      movietrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    print(movietrailerslist);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
    body: FutureBuilder(future: Moviedetails(), 
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
                                                        background: FittedBox(fit: BoxFit.fill,child: trailerwatch(trailerytid:  movietrailerslist[0]['key'],),),),
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
                                    itemCount: MoviesGeneres.length,
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
                                              Text(MoviesGeneres[index]));
                                    })),
                          ]),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                      MovieDetails[0]['runtime'].toString() +
                                          ' min'))
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text('Movie Story :')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                              MovieDetails[0]['overview'].toString())),

                      
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Release Date : ' +
                              MovieDetails[0]['release_date'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Budget : ' +
                              MovieDetails[0]['budget'].toString())),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text('Revenue : ' +
                              MovieDetails[0]['revenue'].toString())),
                      sliderlist(similarmovieslist, "Similar Movies", "movie",
                          similarmovieslist.length),
                      sliderlist(recommendedmovieslist, "Recommended Movies",
                          "movie", recommendedmovieslist.length),]),

                                  
                          )],);

                          }
                          else{return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));}
                        }),);
  }
}