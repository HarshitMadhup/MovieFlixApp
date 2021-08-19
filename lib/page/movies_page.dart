import 'package:flutter/material.dart';
import 'package:movieflix/db/Movies_database.dart';
import 'package:movieflix/model/movie.dart';
import 'package:movieflix/page/Movie_detail_page.dart';
import 'package:movieflix/page/edit_Movie_page.dart';
import 'package:movieflix/widget/movie_card_widget.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List<Movie> movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshMovies();
  }

  @override
  void dispose() {
    MoviesDatabase.instance.close();

    super.dispose();
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);

    this.movies = await MoviesDatabase.instance.readAllMovies();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black,
          title: Center(
            child: Text(
              'MovieFlix',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : movies.isEmpty
                  ? Text(
                      'No Movies',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )
                  : buildMovies(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditMoviePage()),
            );

            refreshMovies();
          },
        ),
      );

  Widget buildMovies() => ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MovieDetailPage(movieId: movie.id!),
              ));

              refreshMovies();
            },
            child: MovieCardWidget(movie: movie, index: index),
          );
        },
      );
}
