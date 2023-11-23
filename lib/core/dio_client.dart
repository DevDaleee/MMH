// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mmh/classes/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient extends RestClient {
  Dio dio =
      Dio(BaseOptions(baseUrl: 'https://apimmh-production.up.railway.app'));

  @override
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? params}) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = _sharedPreferences.getString('access_token');
    final response = await dio.get(path,
        queryParameters: params,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'content-Type': 'application/json'
        }));
    return response.data;
  }

  @override
  Future<Map> post(String path, Map<String, dynamic> data) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = _sharedPreferences.getString('access_token');
    final response = await dio.post(path,
        data: data,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'content-Type': 'application/json'
        }));
    return response.data;
  }

  @override
  Future<Map> patch(String path, Map<String, dynamic> data) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    String? token = _sharedPreferences.getString('access_token');
    final response = await dio.patch(path,
        data: data,
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'content-Type': 'application/json'
        }));
    return response.data;
  }

  @override
  Future<Map> delete(String path, String data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString('access_token');

    try {
      final response = await dio.delete('$path/$data',
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'content-Type': 'application/json'
          }));
      return response.data;
    } catch (e) {
      print('Erro $e');
      rethrow;
    }
  }
}
