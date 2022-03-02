import 'dart:async';

import 'package:get/get.dart';
import 'package:moviefront/Model/Movie.dart';
import 'package:moviefront/service.dart';

class MovieController extends GetxController {
  RxBool isMovieLoading = false.obs;
  RxList<Movie> movies = <Movie>[].obs;
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

  @override
  void onInit() {
    super.onInit();
    getMovies();
  }
}
