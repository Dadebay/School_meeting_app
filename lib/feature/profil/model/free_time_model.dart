class FreeTimeModel {
  final int id;
  final String date;
  final String timeStart;
  final String timeEnd;

  FreeTimeModel({required this.id, required this.date, required this.timeStart, required this.timeEnd});

  factory FreeTimeModel.fromJson(Map<String, dynamic> json) {
    return FreeTimeModel(
      id: json['id'] as int,
      date: json['date'].toString(),
      timeStart: json['timestart'].toString(),
      timeEnd: json['timeend'].toString(),
    );
  }
}
