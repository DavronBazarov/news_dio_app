import 'package:dio/dio.dart';
import 'package:news_dio_app/models/NewsResponce.dart';

class NewsApiServices {
  static String _apiKey = "9275dfc9f4424e97a5c2512f94e81f36";

  String _url =
      "https://newsapi.org/v2/everything?q=apple&from=2022-10-22&to=2022-10-22&sortBy=popularity&apiKey=$_apiKey";

  Dio? _dio;

  NewsApiServices() {
    _dio = Dio();
  }

  Future<List<Article>?> fetchNewsArticles() async {
    try {
      Response response = await _dio!.get(_url);
      NewsResponse newsResponse = NewsResponse.fromJson(response.data);
      return newsResponse.articles;
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }
}
