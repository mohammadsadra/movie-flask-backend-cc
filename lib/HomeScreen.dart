import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:moviefront/movie_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(8, 11, 34, 1),
      appBar: AppBar(
        title: const Text('Mohas Movie'),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 1) {}
              if (value == 2) {}
              if (value == 3) {}
              if (value == 4) {}
            },
            color: const Color.fromRGBO(29, 31, 53, 1),
            icon: const Icon(Icons.language),
            itemBuilder: (context) => const [
              PopupMenuItem(
                height: 20,
                padding: EdgeInsets.all(10),
                child: Text(
                  'English',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                height: 20,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Arabic',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                height: 20,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Spanish',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: 1,
              ),
              PopupMenuItem(
                height: 20,
                padding: EdgeInsets.all(10),
                child: Text(
                  'French',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: 1,
              ),
            ],
          ),
        ],
        centerTitle: false,
        backgroundColor: const Color.fromRGBO(8, 11, 34, 1),
        elevation: 0,
      ),
      body: GetBuilder<MovieController>(
        init: MovieController(),
        builder: (movie) {
          return !movie.isMovieLoading.value
              ? ListView.builder(
                  itemCount: movie.movies.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(18, 20, 44, 1),
                      ),
                      child: Column(
                        children: [
                          Text(
                            movie.movies[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              movie.movies[index].poster,
                              width: 300,
                              height: 300,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Director: ' + movie.movies[index].director,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromRGBO(29, 31, 53, 1),
                                  ),
                                  child: const Text(
                                    'Comments',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    final fileBytes = result.files.first.bytes;
                                    final fileName = result.files.first.name;

                                    await movie.sendComment(
                                      fileBytes,
                                      fileName,
                                      movie.movies[index].id,
                                    );
                                  } else {
                                    Get.snackbar(
                                        'Error', 'You cancled file picker.');
                                  }
                                },
                                child: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromRGBO(29, 31, 53, 1),
                                  ),
                                  child: const Text(
                                    'Add Comment',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
        },
      ),
    );
  }
}
