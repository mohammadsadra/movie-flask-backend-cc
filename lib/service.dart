import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moviefront/Model/Movie.dart';
import 'package:get/get.dart';

class Service {
  final box = GetStorage();
  late Dio dio;

  Service() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://movie-backend-imohammadsadra.fandogh.cloud/',
      ),
    );
  }

  Future getChannels() async {
    try {
      var response = await Service().dio.get('/movies');
      List<Movie> loaded = [];
      for (int i = 0; i < response.data.length; i++) {
        var res = Movie.fromJson(response.data[i]);
        loaded.add(res);
      }
      return loaded;
    } on DioError catch (e) {
      if (e.response != null) {
        Get.snackbar(
          'Failed!',
          'Try again!',
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
        );
        return e.response;
      }
    }
  }
}
