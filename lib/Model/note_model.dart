class Note{
  final int? id;
  final String title;
  final String content;
  final int userId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId
  });

  Note copy({int? id, String? title, String? content, required userId,}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'title':title,
      'content':content,
      'userId':userId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      userId: map['userId'] is String
          ? int.parse(map['userId'])
          : map['userId'],
    );
  }
}