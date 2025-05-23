class NoteModel {
  String name;
  String content;
  bool isFavorited;

  NoteModel({
    required this.name,
    required this.content,
    required this.isFavorited,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'content': content,
        'isFavorited': isFavorited,
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      name: json['name'] ?? '',
      content: json['content'] ?? '',
      isFavorited: json['isFavorited'],
    );
  }
}

