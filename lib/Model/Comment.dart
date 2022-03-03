class Comment {
  late String comment;
  late int id;
  late String username;

  Comment({required this.comment, required this.id, required this.username});

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['id'] = this.id;
    data['username'] = this.username;
    return data;
  }
}
