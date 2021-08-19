import 'dart:io';

import 'package:flutter/material.dart';

import '../model/movie.dart';

class MovieCardWidget extends StatelessWidget {
  MovieCardWidget({
    Key? key,
    required this.movie,
    required this.index,
  }) : super(key: key);

  final Movie movie;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = Colors.white;

    final minHeight = 120.00;

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Director:- " + movie.description,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              // Row(
              //   children: [
              //     IconButton(onPressed: () {}, icon: Icon(Icons.edit))
              //   ],
              // )
            ],
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(movie.posterpath)),
                    fit: BoxFit.contain)),
          )
        ]),
      ),
    );
  }
}
