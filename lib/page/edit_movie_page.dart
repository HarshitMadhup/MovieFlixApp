import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:movieflix/db/Movies_database.dart';
import 'package:movieflix/model/movie.dart';

import 'package:movieflix/widget/movie_form_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as Path;

class AddEditMoviePage extends StatefulWidget {
  final Movie? movie;

  const AddEditMoviePage({
    Key? key,
    this.movie,
  }) : super(key: key);
  @override
  _AddEditMoviePageState createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;
  late String posterpath;

  @override
  void initState() {
    super.initState();

    title = widget.movie?.title ?? '';
    description = widget.movie?.description ?? '';
    posterpath = widget.movie?.posterpath ?? '';
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.insert_photo),
              color: Colors.white,
              onPressed: () {
                getImage(ImageSource.gallery);
              },
            ),
            buildButton()
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _formKey,
              child: MovieFormWidget(
                title: title,
                description: description,
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDescription: (description) =>
                    setState(() => this.description = description),
              ),
            ),
            posterpath.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(50),
                    child: Image.file(File(posterpath)))
                : Container()
          ]),
        ),
      );

  Widget buildButton() {
    final isFormValid =
        title.isNotEmpty && description.isNotEmpty && posterpath.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMovie,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateMovie() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.movie != null;

      if (isUpdating) {
        await updateMovie();
      } else {
        await addMovie();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateMovie() async {
    final movie = widget.movie!
        .copy(title: title, description: description, posterpath: posterpath);

    await MoviesDatabase.instance.update(movie);
  }

  Future addMovie() async {
    final movie =
        Movie(title: title, description: description, posterpath: posterpath);

    await MoviesDatabase.instance.create(movie);
  }

  void getImage(ImageSource imageSource) async {
    XFile? imageFile = await picker.pickImage(source: imageSource);
    if (imageFile == null) return;
    File tmpFile = File(imageFile.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = Path.basename(imageFile.path);
    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');
    setState(() {
      this.posterpath = tmpFile.path;
    });
  }
}
