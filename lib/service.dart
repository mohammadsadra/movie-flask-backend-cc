import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as gg;
import 'package:get_storage/get_storage.dart';
import 'package:moviefront/Model/Comment.dart';
import 'package:moviefront/Model/Movie.dart';

class Service {
  final box = GetStorage();
  late Dio dio;

  Service() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://127.0.0.1:5000/',
        // baseUrl: 'https://movie-python-back-imohammadsadra.fandogh.cloud',
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
        return e.response;
      }
    }
  }

  Future getMovieComments(id, lang) async {
    try {
      var response =
          await Service().dio.get('/getComments/$id' + '?lang=' + lang);
      print(response.data);
      List<Comment> loaded = [];
      if (response.data == null) {
        return loaded;
      }

      for (int i = 0; i < response.data.length; i++) {
        var res = Comment.fromJson(response.data[i]);
        loaded.add(res);
      }

      return loaded;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response;
      }
    }
  }

  Future uploadFile(file, filename, id) async {
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(file, filename: filename),
    });
    var response =
        await Service().dio.post("/uploadVoiceFile/$id", data: formData);
    gg.Get.snackbar(
      'Status',
      response.data['value'],
      colorText: Colors.white,
    );
    return response.data['value'];
  }
}
