import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviefront/Model/Comment.dart';
import 'package:moviefront/Model/Movie.dart';
import 'package:moviefront/service.dart';

class MovieController extends GetxController {
  RxBool isMovieLoading = false.obs;
  RxBool isVoiceSending = false.obs;
  RxBool isCommentLoading = false.obs;
  RxString language = 'en'.obs;
  RxList<Movie> movies = <Movie>[].obs;
  RxList<Comment> movieCms = <Comment>[].obs;
  Future getMovies() async {
    isMovieLoading.value = true;
    var response = Service().getChannels();
    response.then(
      (value) => {
        movies.value = value,
        isMovieLoading.value = false,
        update(),
      },
    );
  }

  Future getMovieComments(id) async {
    movieCms.value = [];
    isCommentLoading.value = true;
    var response = Service().getMovieComments(id, language.value);
    response.then(
      (value) => {
        movieCms.value = value,
        isCommentLoading.value = false,
        update(),
      },
    );
  }

  Future sendComment(file, filename, id) async {
    isVoiceSending.value = true;
    update();
    var response = Service().uploadFile(file, filename, id);
    response.then(
      (value) => {
        isVoiceSending.value = false,
        update(),
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    getMovies();
  }
}
