import 'main.dart';

Future<dynamic> postData(String url, dynamic data) async {
  var request = await dio.post(url, data: data);
  return request.data;
}

Future<dynamic> getData(String url) async {
  var request = await dio.get(url);
  return request.data;
}
