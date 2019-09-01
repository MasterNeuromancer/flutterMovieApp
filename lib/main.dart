import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Movie> fetchMovie() async {
  final response =
      await http.get('http://www.omdbapi.com/?apikey=84d30a86&t=Titanic');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Movie.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load Movie');
  }
}

class Movie {
  final String title;
  final String year;
  final String director;
  final String actors;
  final String plot;

  Movie({this.title, this.year, this.director, this.actors, this.plot});

  factory Movie.fromJson(Map<String, dynamic> json) {
    var movie = Movie(
      title: json['Title'],
      year: json['Year'],
      director: json['Director'],
      actors: json['Actors'],
      plot: json['Plot'],
    );
    return movie;
  }
}

void main() => runApp(MyApp(movie: fetchMovie()));

class MyApp extends StatelessWidget {
  final Future<Movie> movie;

  MyApp({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Movie>(
            future: movie,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.plot);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
