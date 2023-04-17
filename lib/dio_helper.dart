// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'main.dart';

Future<dynamic> postData(String url, dynamic data, BuildContext context) async {
  try {
    var request = await dio.post(url, data: data);
    return request.data;
  } catch (e) {
    if (e is DioError) {
      if (e.response!.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainWidget(),
          ),
        );
      }
    }
    return "";
  }
}

Future<dynamic> getData(String url, BuildContext context) async {
  try {
    var request = await dio.get(url);
    return request.data;
  } catch (e) {
    if (e is DioError) {
      if (e.response!.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainWidget(),
          ),
        );
      }
    }
    return "";
  }
}
