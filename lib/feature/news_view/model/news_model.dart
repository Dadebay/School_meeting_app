class NewsModel {
  final int id;
  final String title;
  final String content;
  final String img;
  final String date;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.img,
    required this.date,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }
}
