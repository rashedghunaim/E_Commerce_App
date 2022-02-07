import 'package:dio/dio.dart';

class DioHelper {
  static var dio = Dio();

  static void initializeDio() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: 'https://student.valuxapps.com/api/',

        /// here we added headers why ? because the Content-type is a constant ,
      ),
    );
  }

  static Future<Response> fetchData({
    required String path,
    Map<String, dynamic>? query,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json'
    };
    // token??'' => means if it a null then put '' else put token  .
    // now here we access the baseOptions from the dio object and add the headers .
    return await dio.get(path, queryParameters: query);
  }

  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json'
    };
    return await dio.post(path, queryParameters: query, data: data);
  }

  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json'
    };
    return await dio.put(
      path,
      data: data,
      queryParameters: query,
    );
  }
}
