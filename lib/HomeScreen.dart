import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:moviefront/movie_controller.dart';

class HomeScreen extends StatelessWidget {
  var mviCtrl = Get.put(MovieController());
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
              if (value == 1) {
                mviCtrl.language.value = 'en';
                mviCtrl.update();
              }
              if (value == 2) {
                mviCtrl.language.value = 'ar';
                mviCtrl.update();
              }
              if (value == 3) {
                mviCtrl.language.value = 'es';
                mviCtrl.update();
              }
              if (value == 4) {
                mviCtrl.language.value = 'fr';
                mviCtrl.update();
              }
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
                value: 2,
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
                value: 3,
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
                value: 4,
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
                                onTap: () async {
                                  movie
                                      .getMovieComments(movie.movies[index].id)
                                      .then(
                                        (value) => {
                                          movie.update(),
                                          _openSheet(context),
                                        },
                                      );
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
                                      'Error',
                                      'You cancled file picker.',
                                      colorText: Colors.white,
                                    );
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
                                  child: movie.isVoiceSending.value
                                      ? const CircularProgressIndicator()
                                      : const Text(
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

  Widget makeDissmissble({required Widget child, context}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  void _openSheet(context) {
    var ctrl = Get.put(MovieController());
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return makeDissmissble(
            context: context,
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(8, 11, 34, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Obx(() {
                        return !ctrl.isCommentLoading.value
                            ? createCommentList()
                            : const Center(child: CircularProgressIndicator());
                      }),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget createCommentList() {
    List<Widget> list = [];
    var ctrl = Get.put(MovieController());
    if (ctrl.movieCms.isNotEmpty) {
      list.add(Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 20),
        child: const Text(
          'All comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
      for (var i = 0; i < ctrl.movieCms.length; i++) {
        list.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width - 50,
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.movieCms[i].username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ctrl.movieCms[i].comment,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        list.add(Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5),
          color: Colors.white,
          height: 1,
          width: Get.width,
        ));
      }
    } else {
      list.add(
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: const Text(
            'No comments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      );
    }

    return Column(children: list);
  }
}
