import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class DataFormatException implements Exception {
  final String message;
  DataFormatException(this.message);
  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => message;
}

post(String url, body) async {
  try {
    Response response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      try {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } on FormatException catch (e) {
        throw DataFormatException('خطأ في تنسيق البيانات: $e');
      }
    } else {
      throw ServerException('خطأ في الخادم: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    print('Network error: $e');
    throw NetworkException('خطأ في الاتصال بالشبكة');
  } on ServerException catch (e) {
    print('Server error: $e');
    rethrow;
  } on DataFormatException catch (e) {
    print('Data format error: $e');
    rethrow;
  } on Exception catch (e) {
    print('Unexpected error: $e');
    throw NetworkException('حدث خطأ غير متوقع');
  }
}

getnames(String url) async {
  try {
    Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } on FormatException catch (e) {
        throw DataFormatException('خطأ في تنسيق البيانات: $e');
      }
    } else {
      throw ServerException('خطأ في الخادم: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    print('Network error: $e');
    throw NetworkException('خطأ في الاتصال بالشبكة');
  } on ServerException catch (e) {
    print('Server error: $e');
    rethrow;
  } on DataFormatException catch (e) {
    print('Data format error: $e');
    rethrow;
  } on Exception catch (e) {
    print('Unexpected error: $e');
    throw NetworkException('حدث خطأ غير متوقع');
  }
}
