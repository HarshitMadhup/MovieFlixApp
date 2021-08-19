final String tableMovies = 'movies';

class MovieFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, posterpath
  ];

  static final String id = '_id';

  static final String title = 'title';
  static final String description = 'description';
  static final String posterpath = 'posterpath';
}

class Movie {
  final int? id;

  final String title;
  final String description;
  final String posterpath;

  const Movie(
      {this.id,
      required this.title,
      required this.description,
      required this.posterpath});

  Movie copy(
          {int? id, String? title, String? description, String? posterpath}) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        posterpath: posterpath ?? this.posterpath,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
      id: json[MovieFields.id] as int?,
      title: json[MovieFields.title] as String,
      description: json[MovieFields.description] as String,
      posterpath: json[MovieFields.posterpath] as String);

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.title: title,
        MovieFields.description: description,
        MovieFields.posterpath: posterpath
      };
}
