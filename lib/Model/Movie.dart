class Movie {
  late String director;
  late int id;
  late String name;
  late String poster;

  Movie(
      {required this.director,
      required this.id,
      required this.name,
      required this.poster});

  Movie.fromJson(Map<String, dynamic> json) {
    director = json['director'];
    id = json['id'];
    name = json['name'];
    poster = json['poster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['director'] = this.director;
    data['id'] = this.id;
    data['name'] = this.name;
    data['poster'] = this.poster;
    return data;
  }
}
