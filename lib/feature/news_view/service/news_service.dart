import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/news_view/model/news_model.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';

class NewsService {
  static Future<List<NewsModel>> fetchNews() async {
    final url = Uri.parse(ApiConstants.newsUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      print('Decoded Response: $utf8Body'); // Yanıtı kontrol etmek için logla
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
      return data.map((json) => NewsModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
