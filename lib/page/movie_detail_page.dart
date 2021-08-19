import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movieflix/db/Movies_database.dart';
import 'package:movieflix/model/movie.dart';
import 'package:movieflix/page/edit_Movie_page.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Movie movie;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshMovie();
  }

  Future refreshMovie() async {
    setState(() => isLoading = true);

    this.movie = await MoviesDatabase.instance.readMovie(widget.movieId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(12, 30, 12, 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 37,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Director:- " + movie.description,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                        softWrap: true,
                      ),
                      Padding(
                          padding: EdgeInsets.all(50),
                          child: Image.file(File(movie.posterpath)))
                    ],
                  ),
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditMoviePage(movie: movie),
        ));

        refreshMovie();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await MoviesDatabase.instance.delete(widget.movieId);

          Navigator.of(context).pop();
        },
      );
}
